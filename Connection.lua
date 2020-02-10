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
    ipTimer:alarm(1000, 1, function() checkAP()  end)
end

function checkAP()
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

function normalMode (ssid,password,ipaddr,subnet,gateway)
    if ipTimer ~= nil then
        print('ip timer found resetting')
        ipTimer:unregister()
    end
    wifi.setmode(wifi.STATION)
    station_cfg={}
    station_cfg.ssid = ssid
    station_cfg.pwd = password
    station_cfg.save = false
    wifi.sta.config(station_cfg)

    ip_cfg = {}
    ip_cfg.ip = ipaddr
    ip_cfg.netmask = subnet
    ip_cfg.gateway = gateway
    wifi.sta.setip(ip_cfg)
    
    ipTimer = tmr.create()
    ipTimer:alarm(1000, 1, function() checkSTA()  end)
end

function checkSTA()
if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print("IP: ",wifi.sta.getip())
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
        conn:on("receive", onConnReceive)
        conn:on("sent", onConnSent)
        end)
end

function onConnReceive (sck, payload)
  lines = {}
  for s in payload:gmatch("[^\r\n]+") do
      --print (s);
      table.insert(lines, s)
  end
  --for key,value in pairs(lines) do print(key,value) end
  print (lines[1])
  postparse={string.find(payload,"mcu_do=")}

  if (#postparse == 0) then
    sck:send('HTTP/1.1 200 OK\n\n')
    sck:send([[<!DOCTYPE html>
    <html>
    <body>
    
    <h2>VMix Tally Configuration</h2>
    
    <form action="" method="POST">
      SSID:<br>
      <input type="text" name="mcu_do" value="Sam House 2">
      <br>
      Password:<br>
      <input type="text" name="mcu_do" value="Viewsonic231">
      <br>
      IP Address:<br>
      <input type="text" name="mcu_do" value="192.168.1.180">
      <br>
      Subnet<br>
      <input type="text" name="mcu_do" value="255.255.255.0">
      <br>
      Gateway:<br>
      <input type="text" name="mcu_do" value="192.168.1.1">
      <br><br>
      <input type="submit" value="Submit">
    </form> 
    
    <p>If you click the "Submit" button, the form-data will be sent to a page called "/action_page.php".</p>
    
    </body>
    </html>]])
  else
    parsed = mysplit (string.gsub(lines[1], "mcu_do=", ""), "&")
    normalMode(parsed[1], parsed[2], parsed[3], parsed[4], parsed[5])
  end
end

function onConnSent (sck, payload)
    sck:close()
end

function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

--setupMode()
normalMode ('Sam House 2', 'Viewsonic231', '192.168.1.118', '255.255.255.0', '192.168.1.1')



