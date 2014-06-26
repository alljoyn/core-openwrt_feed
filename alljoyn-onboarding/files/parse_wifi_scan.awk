# Copyright (c) 2014, AllSeen Alliance. All rights reserved.
#
#    Permission to use, copy, modify, and/or distribute this software for any
#    purpose with or without fee is hereby granted, provided that the above
#    copyright notice and this permission notice appear in all copies.
#
#    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

# This script parses the output from "iw wlan0 scan" to get the list of available AP's
# The fields it lists are:
# "sig" "bssid" "ssid" "encryption type"-"ciphers"
#
# Example for the output with this script
# -43.00 dBm    QGuest  Open
# -51.00 dBm    core3   WPA2-CCMP--PSK
# -53.00 dBm    core2   WPA2-CCMP--PSK
# -54.00 dBm    core1  WPA2-CCMP--PSK
#

# BSS is the bssid but the column appears twice. We want the BSS line and not the BSS Load: line
{ if ($1 == "BSS" && $2 != "Load:") {
    MAC =$2
    wifi[MAC, "BSSID"] = MAC
    wifi[MAC,"enc"] = "Open"
  }
}

$1 == "SSID:" {
    $1="";
    wifi[MAC,"SSID"] =  $0
}

$1 == "signal:" {
    wifi[MAC,"sig"] = $2 " " $3
}
#
# Security: it is not reported directly, check the line starting with capability.
#   * If there is Privacy, for example capability: ESS Privacy ShortSlotTime (0x0411), then the network is protected somehow.
#   * If you see an RSN information block, then the network is protected by Robust Security Network protocol, also known as WPA2.
#   * If you see an WPA information block, then the network is protected by Wi-Fi Protected Access protocol.
#   * In the RSN and WPA blocks you may find the following information:
#      * Group cipher: value in TKIP, CCMP, both, others.
#      * Pairwise ciphers: value in TKIP, CCMP, both, others. Not necessarily the same value than Group cipher.
#      * Authentication suites: value in PSK, 802.1x, others. For home router, you'll usually find PSK (i.e. passphrase).
#        In universities, you are more likely to find 802.1x suite which requires login and password. Then you will need to know which key managemen
#   * If you do not see neither RSN nor WPA blocks but there is Privacy, then WEP is used.
{ if ($1 == "capability:" && $3 == "Privacy") {
    wifi[MAC,"enc"] = "WEP"
  }
}

$1 =="RSN:" {
    wifi[MAC,"enc"] = "WPA2"
    }

$1 == "WPA:" {
    wifi[MAC,"enc"] = "WPA"
}


{ if ($1 == "*"  && $2 == "Authentication" && $3 == "suites:") {
    wifi[MAC,"enc"] =  wifi[MAC,"enc"] "-" $4
  }
}

{ if ($1 == "*"  && $2 == "Pairwise" && $3 == "ciphers:") {
    wifi[MAC,"enc"] =  wifi[MAC,"enc"] "-" $4 "-" $5
  }
}

END {

    for (w in wifi) {
        split(w,sep,SUBSEP)

        if (wifi[sep[1],"SSID"]) {
          printf "%s %s %s\n",wifi[sep[1],"sig"],wifi[sep[1],"enc"],wifi[sep[1],"SSID"]
        }

         # each column is deleted after we printed the information to prevent the info being printed again    
         delete wifi[sep[1],"sig"]
         delete wifi[sep[1],"BSSID"]
         delete wifi[sep[1],"SSID"]
         delete wifi[sep[1],"enc"]
    }
}


