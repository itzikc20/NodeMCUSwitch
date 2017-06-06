
------------Configuration Field-----
WIFI_SSD = "KushKush"
WIFI_PASS = "0542582595"

relay_pin = 6  -- the pin of the switch 

blink_open = "https://s28.postimg.org/xd1frdn19/image.jpg" -- open image
blink_close = "https://s27.postimg.org/57xuqg477/off.jpg"  -- close image
state = "Light Off"
------------------------------------

-- each 10 secound check connection
tmr.alarm(1, 10000, 1, function()
  if wifi.sta.getip() == nil then
    print("Problem accure, reconnectiong...")
    wifi.setmode(wifi.STATION)
   wifi.sta.config(WIFI_SSD,WIFI_PASS) -- Replace these two args with your own network
 
  else
    print("Connected, IP is "..wifi.sta.getip())
  end
end)

----------------
-- GPIO Setup --
----------------
gpio.mode(relay_pin, gpio.OUTPUT)
site_image = blink_close 
gpio.write(relay_pin,gpio.HIGH) 

----------------
-- Web Server --
----------------
print("Starting Web Server...")
-- Create a server object with 30 second timeout
srv = net.createServer(net.TCP, 30)

-- server listen on 80, 
-- if data received, print data to console,
-- then serve up a sweet little website
srv:listen(80,function(conn)
    conn:on("receive", function(conn, payload)
    
        function esp_update()
            mcu_do=string.sub(payload,postparse[2]+1,#payload)
            
            if mcu_do == "TURN+ON" then 
                    site_image = blink_open  
                    print("TURN ON")  
                    gpio.write(relay_pin,gpio.LOW) 
                    state = "Light On"
            end
            
            if mcu_do == "TURN+OFF" then
                print("TURN OFF")
                site_image = blink_close 
                gpio.write(relay_pin,gpio.HIGH) 
                state = "Light Off"
            end
        end

        --parse position POST value from header
        postparse={string.find(payload,"mcu_do=")}
        --If POST value exist, set LED power
        if postparse[2]~=nil then esp_update()end


        -- CREATE WEBSITE --
        
        -- HTML Header Stuff
        conn:send('HTTP/1.1 200 OK\n\n')
        conn:send('<!DOCTYPE HTML>\n')
        conn:send('<html>\n')
        conn:send('<head><meta  content="text/html; charset=utf-8">\n')
        conn:send('<title>Gilboa 42A Light yard</title></head>\n')
        conn:send('<body><center><h1>Turn ON/OFF Light</h1>\n')
        conn:send('<IMG SRC="'..site_image..'" WIDTH="50" HEIGHT="50" BORDER="1"><br><br>\n')
        -- Buttons 
        conn:send('<form action="" method="POST">\n')
        conn:send('<input type="submit" name="mcu_do" value="TURN ON">&nbsp;&nbsp;&nbsp;\n')
        conn:send('<input type="submit" name="mcu_do" value="TURN OFF">\n')
        conn:send('\n<br><br><br><br><hr>Current state is : '..state..'')
        conn:send('\n<br>The Relay is connected to pin : '..relay_pin..'')
        conn:send('</center></body></html>\n')
        conn:on("sent", function(conn) conn:close() end)
    end)
end)
