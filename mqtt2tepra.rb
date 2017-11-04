#!/usr/bin/ruby
require 'mqtt'
require 'yaml'
require 'ostruct'
require 'pp'

$stdout.sync = true
Dir.chdir(File.dirname($0))
$current_dir = Dir.pwd

$log = Logger.new(STDOUT)
$log.level = Logger::DEBUG

$log.info "$current_dir=" + $current_dir

$conf = OpenStruct.new(YAML.load_file("config.yaml"))

conn_opts = {
  remote_host: $conf.mqtt_host
}

if !$conf.mqtt_port.nil? 
  conn_opts["remote_port"] = $conf.mqtt_port
end

if $conf.mqtt_use_auth == true
  conn_opts["username"] = $conf.mqtt_username
  conn_opts["password"] = $conf.mqtt_password
end

def print_tepra(msg)
  $log.info "msg=#{msg}, size=#{msg.size}"

  spc10_path = "c:/Program Files/KING JIM/TEPRA SPC10/SPC10.exe"

  # choice tpe file
  tpe_path   = $current_dir + "/template-9mm-12.tpe"
  if msg.size <= 4
    tpe_path   = $current_dir + "/template-9mm-4.tpe"
  elsif msg.size <= 8
    tpe_path   = $current_dir + "/template-9mm-8.tpe"
  end

  # create csv file
  csv_path   = $current_dir + "/_nagashikomi.csv"
  open(csv_path, "w", :encoding => "SJIS" ) do |f|
    f.puts msg
  end

  # exec...
  cmd = "\"#{spc10_path}\" /pt \"#{tpe_path},#{csv_path},1,/C -f -hn,/TW -off\" \"KING JIM SR5900P-NW\""
  $log.info "exec cmd=" + cmd

  spawn(cmd)


end

loop do
  begin
    $log.info "connecting..." 
    MQTT::Client.connect(conn_opts) do |c|
      $log.info "connected!" 
      $log.info "subscribe topid=" + $conf.mqtt_subscribe_topic
      c.get($conf.mqtt_subscribe_topic) do |t, msg|
	msg = msg.force_encoding("UTF-8")
        msg.chomp!
        msg.strip!
        msg.gsub!(/\s/, "")
	print_tepra(msg)
      end
    end
  rescue Exception => e
    puts e
  end
  $log.error "reconnectiong..."
  sleep 7
end
