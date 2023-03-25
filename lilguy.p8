pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
//global functions and variables
level = {
         diag_ladders={},
         straight_ladders={},
         balconies={}}

function level:new (o)
   o = o or {}
   setmetatable(o,self)
   self.__index = self 
   self.diag_ladders = {}
   self.straight_ladders = {}
   self.balconies = {}
   return o
end

opp_pos = {0,0}

opp_state = "walk"
opp_flip = {false,false}

l1 = level:new(nil)
l1.diag_ladders[1] = {56,80}
l1.diag_ladders[2] = {64,72}
l1.diag_ladders[3] = {72,64}
l1.straight_ladders[1] = {56,99}
l1.straight_ladders[2] = {56,107}
l1.straight_ladders[3] = {56, 115}
l1.balconies[1] = {10,20}
l1.balconies[2] = {64,52}
l1.balconies[3] = {10,84}


-->8
//drawing functions
function draw_background(level)
   palt()
   // draw building
   map(0,0 ,0,0,  16, 16,0)
   map(0,16,0,120,16,1,0)
   
   palt(0, false)
   palt(15,true) 
   
   foreach(level.straight_ladders,draw_ladder_straight)
   foreach(level.diag_ladders,draw_ladder_diag)   
   palt() 
end


function draw_foreground(level)  
   palt(0, false)
   palt(15,true)
   foreach(level.balconies,draw_gate)
--   draw_gate(10,20)
--   draw_gate(64,52)
--   draw_gate(10,84)
   palt()
end


function draw_opossum(sx,sy, state, flipped)
   print(state)
   index = 41 
   if ( state == "climb" ) 
   then
      index = 42
   end
   spr(index,sx,sy,1,1,flipped[1], flipped[2])
end

function can_climb(level,y_pos)
  loc_x = opp_pos[1] + 4
  loc_y = y_pos + 7 
  for ladder in all(level.straight_ladders)
  do
     lad_x = ladder[1] + 4
     lad_y = ladder[2] + 4
     if ( abs(loc_x - lad_x ) < 4 and
          abs(loc_y - lad_y ) < 7 ) 
     then
       return true
     end     
  end
  
  return false
end

function can_walk(level,xpos)
  loc_x = xpos
  loc_y = opp_pos[2]+4  

end


-->8
function draw_gate(coord)  
  map(16,0,coord[1],coord[2],7,2,0)	
end

function draw_ladder_straight(coord) 
  spr(28,coord[1],coord[2])  
end

function draw_ladder_diag(coord)
  spr(23,coord[1],coord[2],2,1)
end
-->8
function _init()
  poke4(0x5f10,0x8382.8180)
  poke4(0x5f14,0x8786.8584)
  poke4(0x5f18,0x8b8a.8988)
  poke4(0x5f1c,0x8f8e.8d8c)
  opp_pos = {50,115}
  end

function _draw()
   cls()
   draw_background(l1)
   draw_opossum(opp_pos[1], opp_pos[2],opp_state, opp_flip)
   draw_foreground(l1)
   camera(0,0)
end

function _update()
  
  if(btn(0))
  then  
     opp_state = "walk" 
     opp_pos[1] -= 1
     opp_flip = {true,false}
  end
  if(btn(1)) 
  then 
     opp_state ="walk"
     opp_pos[1] += 1
     opp_flip = {false,false}
  end
  if(btn(2) and can_climb(l1,opp_pos[2] -1)) 
  then 
    opp_state = "climb"
    opp_pos[2] -= 1
    opp_flip = {false,false}
	 end
	 if(btn(3) and can_climb(l1,opp_pos[2] +1)) 
  then 
    opp_state ="climb"
    opp_pos[2] += 1
    opp_flip = {false,true}
	 end    
end  

__gfx__
00000000c225522255555552255255525255555c00300000000000000000000000000000ffffffffffffffffffffffff00000000222222220000000000000000
00000000cc55555555555555555555555255555c0bb03000003b00000000000000000000ffffffffffffffffffffffff000000002cccccc20000000000000000
00700700cc5555555552555555555555555552ccbb3333b33333bb300000000000000000ffffffffffffffffffffffff000000002cc6ccc20000000000000000
00077000c555225555555555552255555552552c33333333333333330000000000000000ffffffffffffffffffffffff000000002c66ccc20000000000000000
00077000c555225525555522555255555555552c2222222222222222000000000000000000000000000000000000000f000000002c6cccc20000000000000000
00700700cc5555525555255255555555555555cc552555555555555500000000000000000f0f0f0f0f0f0f0f0f0f0f0f000000002cccccc20000000000000000
00000000cc5555225555555555555552555552cc552555555555555500000000000000000f0f0f0f0f0f0f0f0f0f0f0f000000002cc22cc20000000000000000
00000000c252525555525255255555525555555c552555555555555500000000000000000f0f0f0f0f0f0f0f0f0f0f0f00000000222222220000000000000000
00000000c555255525522555552555555255525c0000000000000000ffffffffff00f0f00f0f0f0f0f0f0f0f0f0f0f0ff000000f2cccccc20000000000000000
00000000cc2255555552555255255555555555cc0000000000000000fffffffff00fff000f0f0f0f0f0f0f0f0f0f0f0ff0ffff0f2cccccc20000000000000000
00000000cc5225555555555225555522555555cc0000000000000000ffffffff00f0f00f0f0f0f0f0f0f0f0f0f0f0f0ff000000f2cccccc20000000000000000
00000000c525555555555255555555525555525c0000000000000000fffffff00fff00ff0f0f0f0f0f0f0f0f0f0f0f0ff0ffff0f2cccccc20000000000000000
00000000c555555252555552555555555522552c0000000000000000ffffff00f0f00fff0f0f0f0f0f0f0f0f0f0f0f0ff000000f2ccc66c20000000000000000
00000000cc5555252255552255555555255255cc0000000000000000fffff00fff00ffff0f0f0f0f0f0f0f0f0f0f0f0ff0ffff0f2ccc6cc20000000000000000
00000000cc2555555555255225555255255555cc0000000000000000ffff00f0f00fffff0f0f0f0f0f0f0f0f0f0f0f0ff000000f2cccccc20000000000000000
00000000c525525555555555255555555555525c0000000000000000fff00fff00ffffff00000000000000000000000ff0ffff0f222222220000000000000000
00000000000000000000000000000000000000000000000000000000ff00f0f00fffffff00000000000770000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffff00000000005775000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffff00000000000660000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffff00000000006666000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffff00000000006666000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffff00066650006666000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffff00666677000700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffff7766667e000770000000000000000000000000000000000000000000
__map__
01020302020203031313030303020204090a0a0a0a0a0b000000000065666768696a6b6c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01121303121313121213031202020214191a1a1a1a1a1b000000000075767778797a7b7c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11020d020d130d121212030d030d020400000000000000000000000085868788898a8b8c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01031d131d021d020303031d121d020400000000000000000000000095969798999a9b9c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102031302020312130302020302021400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0112131303121302020302121302030400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020d020d0303021213020d120d030400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11031d031d0202030313131d031d030400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103020302021303030302121202031400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030202031302031312121202020400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01030d020d030203030d120d020d020400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11021d021d021213121d121d031d030400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1102020312121212131312130303031400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112121203031213121212121303031400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103121203121213131303031303031400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102030202030302020303020202030400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0605060605060605060605060605060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
