require 'resolv'
require 'colorize'


module PeepRBL

  RBLS = [
    'all.s5h.net',
    'b.barracudacentral.org',
    'bl.emailbasura.org',
    'bl.spamcannibal.org',
    'bl.spamcop.net',
    'blackholes.five-ten-sg.com',
    'blacklist.woody.ch',
    'bogons.cymru.com',
    'cbl.abuseat.org',
    'cdl.anti-spam.org.cn',
    'combined.abuse.ch',
    'combined.rbl.msrbl.net',
    'db.wpbl.info',
    'dnsbl-1.uceprotect.net',
    'dnsbl-2.uceprotect.net',
    'dnsbl-3.uceprotect.net',
    'dnsbl.anticaptcha.net',
    'dnsbl.cyberlogic.net',
    'dnsbl.inps.de',
    'dnsbl.sorbs.net',
    'drone.abuse.ch',
    'drone.abuse.ch',
    'duinv.aupads.org',
    'dul.dnsbl.sorbs.net',
    'dyna.spamrats.com',
    'dynip.rothen.com',
    'exitnodes.tor.dnsbl.sectoor.de',
    'http.dnsbl.sorbs.net',
    'images.rbl.msrbl.net',
    'ips.backscatterer.org',
    'ix.dnsbl.manitu.net',
    'korea.services.net',
    'misc.dnsbl.sorbs.net',
    'noptr.spamrats.com',
    'orvedb.aupads.org',
    'pbl.spamhaus.org',
    'phishing.rbl.msrbl.net',
    'proxy.bl.gweep.ca',
    'psbl.surriel.com',
    'rbl.interserver.net',
    'rbl.megarbl.net',
    'relays.bl.gweep.ca',
    'relays.bl.kundenserver.de',
    'relays.nether.net',
    'sbl.spamhaus.org',
    'short.rbl.jp',
    'smtp.dnsbl.sorbs.net',
    'socks.dnsbl.sorbs.net',
    'spam.abuse.ch',
    'spam.dnsbl.sorbs.net',
    'spam.rbl.msrbl.net',
    'spam.spamrats.com',
    'spamrbl.imp.ch',
    'ubl.lashback.com',
    'ubl.unsubscore.com',
    'virbl.bit.nl',
    'virus.rbl.jp',
    'virus.rbl.msrbl.net',
    'web.dnsbl.sorbs.net',
    'wormrbl.imp.ch',
    'xbl.spamhaus.org',
    'zen.spamhaus.org',
    'zombie.dnsbl.sorbs.net'
  ]

  def self.reverse_ip(ip)
    ip.split('.').reverse!.join('.')
  end

  def self.display(rbl, listed)
    if listed
      puts rbl[0] + " LISTED!".red
    else
      puts rbl[0] + " PASS".green
    end
  end

  def self.report(options)

    mail_server_ip = options[:mail_server_ip]
           display = options[:display]

    blacklist_report = {}


    rbl_fqdns = RBLS.map {|rbl| [rbl, reverse_ip(mail_server_ip) + '.' + rbl] }

    Resolv::DNS.open do |dns|
      dns.timeouts = 1
      rbl_fqdns.each do |rbl|
        begin
          blacklist_report[rbl[0]] = dns.getaddress(rbl[1])
        rescue
          display(rbl, false) if options[:display]
        else
          display(rbl, true) if options[:display]
          blacklist_report[rbl[0]] = true
        end
      end
    end

    return blacklist_report
  end


end
