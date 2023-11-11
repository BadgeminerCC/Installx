local expect = require "cc.expect".expect
local a={["black"]=0x111111,["blue"]=0x2A7BDE,["brown"]=0xA2734C,["cyan"]=0x2AA1B3,["gray"]=0x444444,["green"]=0x26A269,["lightBlue"]=0x00AEFF,["lightGray"]=0x777777,["lime"]=0x33D17A,["magenta"]=0xC061CB,["orange"]=0xD06018,["pink"]=0xF66151,["purple"]=0xA347BA,["red"]=0xC01C28,["white"]=0xFFFFFF,["yellow"]=0xF3F03E}
for b,c in pairs(a)do _G.term.setPaletteColor(colors[b],c)end

local PrimeUI={}do local b={}local c;function PrimeUI.addTask(d)expect(1,d,"function")local e={coro=coroutine.create(d)}b[#b+1]=e;_,e.filter=coroutine.resume(e.coro)end;function PrimeUI.resolve(...)coroutine.yield(b,...)end;function PrimeUI.clear()term.setCursorPos(1,1)term.setCursorBlink(false)term.setBackgroundColor(colors.black)term.setTextColor(colors.white)term.clear()b={}c=nil end;function PrimeUI.setCursorWindow(f)expect(1,f,"table","nil")c=f and f.restoreCursor end;function PrimeUI.getWindowPos(f,g,h)if f==term then return g,h end;while f~=term.native()and f~=term.current()do if not f.getPosition then return g,h end;local i,j=f.getPosition()g,h=g+i-1,h+j-1;_,f=debug.getupvalue(select(2,debug.getupvalue(f.isColor,1)),1)end;return g,h end;function PrimeUI.run()while true do if c then c()end;local k=table.pack(os.pullEvent())for _,l in ipairs(b)do if l.filter==nil or l.filter==k[1]then local m=table.pack(coroutine.resume(l.coro,table.unpack(k,1,k.n)))if not m[1]then error(m[2],2)end;if m[2]==b then return table.unpack(m,3,m.n)end;l.filter=m[2]end end end end;function PrimeUI.label(f,g,h,n,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,n,"string")o=expect(5,o,"number","nil")or colors.white;p=expect(6,p,"number","nil")or colors.black;f.setCursorPos(g,h)f.setTextColor(o)f.setBackgroundColor(p)f.write(n)end;function PrimeUI.scrollBox(f,g,h,q,r,s,t,u,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")expect(5,r,"number")expect(6,s,"number")expect(7,t,"boolean","nil")expect(8,u,"boolean","nil")o=expect(9,o,"number","nil")or colors.white;p=expect(10,p,"number","nil")or colors.black;if t==nil then t=true end;local v=window.create(f==term and term.current()or f,g,h,q,r)v.setBackgroundColor(p)v.clear()local w=window.create(v,1,1,q-(u and 1 or 0),s)w.setBackgroundColor(p)w.clear()if u then v.setBackgroundColor(p)v.setTextColor(o)v.setCursorPos(q,r)v.write(s>r and"\31"or" ")end;g,h=PrimeUI.getWindowPos(f,g,h)PrimeUI.addTask(function()local x=1;while true do local k=table.pack(os.pullEvent())s=select(2,w.getSize())local y;if k[1]=="key"and t then if k[2]==keys.up then y=-1 elseif k[2]==keys.down then y=1 end elseif k[1]=="mouse_scroll"and k[3]>=g and k[3]<g+q and k[4]>=h and k[4]<h+r then y=k[2]end;if y and(x+y>=1 and x+y<=s-r)then x=x+y;w.reposition(1,2-x)end;if u then v.setBackgroundColor(p)v.setTextColor(o)v.setCursorPos(q,1)v.write(x>1 and"\30"or" ")v.setCursorPos(q,r)v.write(x<s-r and"\31"or" ")end end end)return w end;function PrimeUI.progressBar(f,g,h,q,o,p,z)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")o=expect(5,o,"number","nil")or colors.white;p=expect(6,p,"number","nil")or colors.black;expect(7,z,"boolean","nil")local function A(B)expect(1,B,"number")if B<0 or B>1 then error("bad argument #1 (value out of range)",2)end;f.setCursorPos(g,h)f.setBackgroundColor(p)f.setBackgroundColor(o)f.write((" "):rep(math.floor(B*q)))f.setBackgroundColor(p)f.setTextColor(o)f.write(z and"\x7F"or(" "):rep(q-math.floor(B*q)))end;A(0)return A end;function PrimeUI.horizontalLine(f,g,h,q,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")o=expect(5,o,"number","nil")or colors.white;p=expect(6,p,"number","nil")or colors.black;f.setCursorPos(g,h)f.setTextColor(o)f.setBackgroundColor(p)f.write(("\x8C"):rep(q))end;function PrimeUI.keyAction(C,D)expect(1,C,"number")expect(2,D,"function","string")PrimeUI.addTask(function()while true do local _,E=os.pullEvent("key")if E==C then if type(D)=="string"then PrimeUI.resolve("keyAction",D)else D()end end end end)end;function PrimeUI.textBox(f,g,h,q,r,n,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")expect(5,r,"number")expect(6,n,"string")o=expect(7,o,"number","nil")or colors.white;p=expect(8,p,"number","nil")or colors.black;local F=window.create(f,g,h,q,r)function F.getSize()return q,math.huge end;local function A(G)expect(1,G,"string")F.setBackgroundColor(p)F.setTextColor(o)F.clear()F.setCursorPos(1,1)local H=term.redirect(F)print(G)term.redirect(H)end;A(n)return A end;function PrimeUI.drawText(f,n,I,o,p)expect(1,f,"table")expect(2,n,"string")expect(3,I,"boolean","nil")o=expect(4,o,"number","nil")or colors.white;p=expect(5,p,"number","nil")or colors.black;f.setBackgroundColor(p)f.setTextColor(o)local H=term.redirect(f)local J=print(n)term.redirect(H)if I then local g,h=f.getPosition()local K=f.getSize()f.reposition(g,h,K,J)end;return J end;function PrimeUI.borderBox(f,g,h,q,r,o,p)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,q,"number")expect(5,r,"number")o=expect(6,o,"number","nil")or colors.white;p=expect(7,p,"number","nil")or colors.black;f.setBackgroundColor(p)f.setTextColor(o)f.setCursorPos(g-1,h-1)f.write("\x9C"..("\x8C"):rep(q))f.setBackgroundColor(o)f.setTextColor(p)f.write("\x93")for L=1,r do f.setCursorPos(f.getCursorPos()-1,h+L-1)f.write("\x95")end;f.setBackgroundColor(p)f.setTextColor(o)for L=1,r do f.setCursorPos(g-1,h+L-1)f.write("\x95")end;f.setCursorPos(g-1,h+r)f.write("\x8D"..("\x8C"):rep(q).."\x8E")end;function PrimeUI.button(f,g,h,n,D,o,p,M)expect(1,f,"table")expect(2,g,"number")expect(3,h,"number")expect(4,n,"string")expect(5,D,"function","string")o=expect(6,o,"number","nil")or colors.white;p=expect(7,p,"number","nil")or colors.gray;M=expect(8,M,"number","nil")or colors.lightGray;f.setCursorPos(g,h)f.setBackgroundColor(p)f.setTextColor(o)f.write(" "..n.." ")PrimeUI.addTask(function()local N=false;while true do local O,P,Q,R=os.pullEvent()local S,T=PrimeUI.getWindowPos(f,g,h)if O=="mouse_click"and P==1 and Q>=S and Q<S+#n+2 and R==T then N=true;f.setCursorPos(g,h)f.setBackgroundColor(M)f.setTextColor(o)f.write(" "..n.." ")elseif O=="mouse_up"and P==1 and N then if Q>=S and Q<S+#n+2 and R==T then if type(D)=="string"then PrimeUI.resolve("button",D)else D()end end;f.setCursorPos(g,h)f.setBackgroundColor(p)f.setTextColor(o)f.write(" "..n.." ")end end end)end end;

local w,h =term.getSize()

local function sequence(t,seq)
    
    local ExternalReqirements = {}
    local SRC = 'BadgeminerCC/Installx'
    local acentColor = colors.white
    local function download(urls)
        PrimeUI.clear()
        PrimeUI.label(term.current(), 3, 2, t.." Installer",acentColor)
        PrimeUI.label(term.current(), 3, 4, SRC,acentColor)
        PrimeUI.horizontalLine(term.current(), 3, 3, #(t.." Installer") + 2,acentColor)
        PrimeUI.borderBox(term.current(), 4, 7, w-8, 1,acentColor)
        local progress = PrimeUI.progressBar(term.current(), 4, 7, w-8, nil, nil, true)
        local function Download()
            local amt = 1/(#urls*2)
            local count = 0
            for i,url in ipairs(urls) do
                local R = http.get(url.url)
                count = count +amt
                progress(count)
                sleep()
                local f = fs.open(url.file,'w')
                f.write(R.readAll())
                f.close()
                count = count +amt
                progress(count)
                sleep()
            end
            
            progress(1)
            sleep(0.5)
            PrimeUI.resolve("download", "done")
        end
        PrimeUI.addTask(Download)
        PrimeUI.run()
    end
    local function message(msg)
        PrimeUI.clear()
        PrimeUI.label(term.current(), 3, 2, t.." Installer",acentColor)
        PrimeUI.horizontalLine(term.current(), 3, 3, #(t.." Installer") + 2,acentColor)
        PrimeUI.label(term.current(), 3, 4, SRC,acentColor)
        PrimeUI.borderBox(term.current(), 4, 6, w-8, h-8,acentColor)
        local scroller = PrimeUI.scrollBox(term.current(), 4, 6, w-8, h-8, 9000, true, true,acentColor)
        PrimeUI.drawText(scroller, msg, true)
        
        PrimeUI.button(term.current(), 3, h-1, "Next", "done")
        
        PrimeUI.keyAction(keys.enter, "done")
        PrimeUI.run()
    end
    local env = setmetatable({
        src = function(src)
            SRC = src
        end,
        reqirement = function(name)
            local url = string.format("https://raw.githubusercontent.com/BadgeminerCC/Installx/main/%s.isx",name)
            local r = http.get(url)
            ExternalReqirements[name] = r.readAll()
        end,
        install_reqs = function()
            message(string.format([[ISX Installer
            installing: %s]],SRC))
            for index, value in pairs(ExternalReqirements) do
                sequence(index,value)
            end
        end,
        info = function(i)
            message(i)
        end,
        download = function(i)
            download(i)
        end,
        file = function(url,path)
            return {url=url,file=path}
        end
    },{__index=_ENV})
    local fn, err = load(seq,"1", "t", env)
    if not fn then
        error("Could not load isx: " .. err)
    end
    local ok, err = pcall(fn)
    if not ok then
        error("Failed to execute isx: " .. err)
    end
end
sequence('testing',[[reqirement("test")
install_reqs()
download({
    file("https://gist.githubusercontent.com/MCJack123/473475f07b980d57dd2bd818026c97e8/raw/faafffa95c356c8f3ab83550d3548059d431accc/redrun.lua",'tmp'),
    file("https://raw.githubusercontent.com/BadgeminerCC/bluenet/main/bluenet.lua",'tmp')
})]])
PrimeUI.clear()