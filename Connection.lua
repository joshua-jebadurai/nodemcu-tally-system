--[[wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid = "Sam House 2"
station_cfg.pwd = "Viewsonic231"
station_cfg.save = false
wifi.sta.config(station_cfg)--]]

function setupMode()
    
    if ipTimer ~= nil then
        print('ip timer found resetting')
        ipTimer:unregister()
    end
    wifi.setmode(wifi.SOFTAP)
    station_cfg={}
    station_cfg.ssid = "TallyModule"
    station_cfg.pwd = "Viewsonic231"
    station_cfg.save = false
    wifi.ap.config(station_cfg)
    
    ipTimer = tmr.create()
    ipTimer:alarm(1000, 1, function() check()  end)
end


function check()
if wifi.ap.getip() == nil then
      print("Connecting to AP...")
   else
      print("IP: ",wifi.ap.getip())
      ipTimer:unregister()
      if srv == nil then
        serverSetup()
      else
        print ('web server already found')
      end
   end
end

function serverSetup ()
print ('starting web server')
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print(payload)
        sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>")
    end)
    conn:on("sent", function(sck) sck:close() end)
end)
end

setupMode()



