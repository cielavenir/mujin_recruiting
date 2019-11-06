#!/usr/bin/ruby
require 'rubygems'
require 'knife-solo'

if Gem::Version.new(KnifeSolo::version) < Gem::Version.new('0.6.0')
    raise '[-] knife-solo is too old.'
elsif Gem::Version.new(KnifeSolo::version) >= Gem::Version.new('0.7.0')
    STDERR.puts '[+] no need to patch.'
else
    path = `VISUAL=echo gem open knife-solo`.chomp+'/lib/knife-solo/bootstraps/linux.rb'
    begin
        f=File.open(path,'r+')
    rescue => e
        STDERR.puts '[-] Failed to open for writing; sudo might be required.'
        STDERR.puts e.inspect
        exit 1
    end
    buf = ''.dup
    f.each_line{|line|
        buf << (line.include?('Debian GNU/Linux') ? "      when %r{Debian GNU/Linux }\n" : line) # Debian GNU/Linux [6789]
    }
    f.rewind
    f.truncate(0)
    f.puts buf
    f.close
    STDERR.puts '[+] patched.'
end
