# =============== HEADER ===============
# RouterOS script: FunctionLibrary
# Copyright (c) 2024-2025 
#  Author: Quach Do Duy 
#  Email: <quachdoduy@gmail.com>
#  Git URL: /quachdoduy/Mikrotik-RouterOS-Script
# --------------------------------------
# Please, keep this header if using this script.
# ============= END HEADER =============

# ==============================
# GLOBAL VARIABLES 
# THAT CANNOT BE CHANGED BY USER
# ==============================

# VARIABLES FOR IDENTITY
:global varIdentity [ /system/identity/get value-name=name ];
:global varSystemID [ /system/license/get value-name=software-id ];

# VARIABLES FOR INFO
:global varLicenseLevel;
:global varSystemPlatform;
:global varSystemBoard;
:global varSystemArchitecture;
:global varSystemFactorySoftware;
:global varSystemSoftwareVersion;

# VARIABLES FOR PERFORMANCE RESOURCE
:global varResCPU;
:global varResCPUCount;
:global varResCPUFreq;
:global varResCPULoad;
:global varResRamTotal;
:global varResRamFree;
:global varResHDDTotal;
:global varResHDDFree;

# VARIABLES FOR SNMP INFO
:global varSNMPEnable;
:global varSNMPContact;
:global varSNMPLocation;
:global varSNMPEngineID;

# VARIABLES FOR LAST CHECK STATUS
:global arrUptiWAN {"";""};               # Variables Uptime WANs
:global varSystemUptime;                  # Variable Uptime Device get by [ /system/resource/get value-name=uptime ];
:global arrPSUlaststatus {"fail";"fail"}; # Variable laststatus of PSUs

# ===========================
# GLOBAL FUNCTION DECLARATION
# ===========================

# Functions use to optimization data
:global funcMonthToNumber;
:global funcGetDate;
:global funcGetTime;
:global funcGenRandomString;
:global funcReplaceChar;
:global funcSplitString;

# Functions use to get infor device
:global funcGetInfo;

# Functions use to write logs
:global funcLogPrint;

# Functions use to notification
:global funcSoundAlert;
:global funcSendEmail;
:global funcSendTelegram;
:global funcSendWebhook;
:global funcSendNotification;

# Functions use to processing
:global funcHealthCheck;

# ===========================
# GLOBAL FUNCTION PROCESSING
# ===========================

# [funcMonthToNumber $1]
#  Convert month from format mmm to mm
#  Exam: [funcMonthToNumber "jan"] = "01"
#  Syntax: [funcMonthToNumber $vinMonthvinMonth]
:set funcMonthToNumber do={
    # declare input variable
    :local vinMonth [ :tostr $1 ];
    
    # declare local / global variable for process
    :local voutMonth;
    :local arrMonth ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");
    :local idxMonth;

    # process
    :set idxMonth [:find $arrMonth $vinMonth -1];
    :if ([:typeof $idxMonth] != "nil") do={
        :if (([:tonum $idxMonth] +1) < 10) do={
            :set voutMonth ("0" . ([:tonum $idxMonth] +1));
        } else { :set voutMonth ([:tonum $idxMonth] +1); }
        :return $voutMonth;
    } else { :return $vinMonth; }
    :return $voutMonth;
};


# [funcGetDate $1]
#  Get date local system. RouterOS return format mmm/DD/YYYY
#  This function has two option format to return. Format: "ISO-8601" or "YYYYMMDD"
#  Exam: [funcGetDate] = feb/01/2025
#        [funcGetDate "ISO-8601"] = 20250201
#        [funcGetDate "YYYYMMDD"] = 20250201
#  Note: This fuction re-use [funcMonthToNumber]
#  Syntax: [funcGetDate $vinFormat]
:set funcGetDate do={
  
    # declare input variable
    :local vinFormat [ :tostr $1 ];

    # declare local / global variable for process
    :local voutDate;
    :global varSysDate;

    # declare for call global function
    :global funcMonthToNumber;

    # process
    :set varSysDate [/system/clock/get value-name=date];

    :if (($vinFormat = "ISO-8601") || ($vinFormat = "YYYYMMDD")) do={
        :local strYear [:pick $varSysDate 7 11];
        :local strMonth [$funcMonthToNumber [:pick $varSysDate 0 3]];
        :local strDate [:pick $varSysDate 4 6];
        :set voutDate ($strYear . $strMonth . $strDate);
    } else { :set voutDate $varSysDate; }
    :return $voutDate;
};


# [funcGetTime $1]
#  Get time local system. RouterOS return format hh:mm:ss
#  This function has two option format to return. Format: "ISO-8601" or "hhmmss"
#  Exam: [funcGetTime] = 08:00:30
#        [funcGetTime "ISO-8601"] = 080030
#        [funcGetTime "hhmmss"] = 080030
#  Syntax: [funcGetTime $vinFormat]
:set funcGetTime do={

    # declare input variable
    :local vinFormat [ :tostr $1 ];

    # declare local / global variable for process
    :local voutTime;
    :global varSysTime;

    # process
    :set varSysTime [/system/clock/get value-name=time];

    :if (($vinFormat = "ISO-8601") || ($vinFormat = "hhmmss")) do={
        :local strHour [:pick $varSysTime 0 2];
        :local strMinute [:pick $varSysTime 3 5];
        :local strSecond [:pick $varSysTime 6 8];

        :set voutTime ($strHour . $strMinute . $strSecond);
    } else { :set voutTime $varSysTime; }
    :return $voutTime;
};


# [funcGenRandomString $1]
#  Generate a random string with number of Charactor input.
#  This function has two option for length to return.
#  Exam: [funcGenRandomString] => Gen Random String with length_default(12)
#        [funcGenRandomString 32] => Gen Random String with length_input(32)
#  Note: Source charator is merge array of Alphabet, Number and Special Charactors.
#         And then catch the characters without getting confused when looking.
#  Syntax: [funcGenRandomString $vinNumOfChar]
:set funcGenRandomString do={

    # declare input variable
    :local vinNumOfChar [ :tostr $1 ];

    # declare local / global variable for process
    :local voutGenString "";
    :local arrAlphabet ("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z");
    :local strNumber "0123456789";
    :local strSpecial "~!@#\$%";
    :local strChars ($strNumber . $strSpecial);
    
    # declare local variable for pick charator in arrAlphabet
    # Be careful when changing
    :local idxPickChar ("1101110110101110011011001010101011011101011101001101");

    # process
    :for i from=0 to=([:len $idxPickChar] - 1) step=1 do={

        # pick char in idxPickChar in position i
        :local idxPickCharCurrent [:pick $idxPickChar $i ($i + 1)];

        # if idxPickCharCurrent value is 1 pick member of arrAlphabet in position i 
        # and insert to arrChars
        :if ($idxPickCharCurrent = "1") do={ :set strChars ($strChars . ($arrAlphabet-> $i)); }
    }

    :if ([:typeof $vinNumOfChar] != "nil") do={
        :set voutGenString [:rndstr from=$strChars length=$vinNumOfChar];
    } else { :set voutGenString [:rndstr from=$strChars length=12]; }
    
    :return $voutGenString;
};


# [funcReplaceChar $1 $2 $3]
#  Find a Charactor then replace by other Charactor in a String.
#  This function has tree parameters.
#  Exam: [funcReplaceChar "Hello! RouterOS" "e" "3"] = "H3llo! Rout3rOS"
#  Syntax: [funcReplaceChar $vinString $chaReplaceFrom $chaReplaceTo]
:set funcReplaceChar do={

    # declare input variable
    :local vinString      [ :tostr $1 ];
    :local chaReplaceFrom [ :tostr $2 ];
    :local chaReplaceTo   [ :tostr $3 ];

    # declare local / global variable for process
    :local voutString "";

    # process
    :if ($chaReplaceFrom = "") do={
        :return $vinString;
    }

    :while ([ :typeof [ :find $vinString $chaReplaceFrom ] ] != "nil") do={
        :local posChar [ :find $vinString $chaReplaceFrom ];
        :set voutString ($voutString . [ :pick $vinString 0 $posChar ] . $chaReplaceTo);
        :set vinString [ :pick $vinString ($posChar + [ :len $chaReplaceFrom ]) [ :len $vinString ] ];
    }
    :return ($voutString . $vinString);
};


# [funcSplitString $1 $2 $3]
#  Get Split String with String input and Char split, option return member of
#  Note: This function re-use [funcReplaceChar]
#  Syntax: [funcSplitString $vinString $chaSplit $optSelect]
:set funcSplitString do={
  
    # declare input variable
    :local vinString [ :tostr $1 ];
    :local chaSplit  [ :tostr $2 ];
    :local optSelect [ :tostr $3 ];

    # declare local / global variable for process
    :local arrString [];
    :local voutString;

    # declare for call global function
    :global funcReplaceChar;

    # process
    :if ($chaSplit = "") do={
        :set voutString $vinString;
    }
    
    :set arrString [ :toarray [$funcReplaceChar $vinString $chaSplit ","] ];

    :if (($optSelect = "") || ($optSelect = 0)) do={
        :set voutString ($arrString->0);
    }

    :if ($optSelect > [:len $arrString]) do={
        :set voutString ($arrString->([:len $arrString] - 1));
    }

    :set voutString ($arrString->($optSelect - 1));
    :return $voutString;
}


# [funcGetInfo]
#  Get information of device then push it to global variable.
#  Syntax: [funcGetInfo]
:set funcGetInfo do={

    # process
    # group License information
    :global varLicenseLevel [ /system/license/get value-name=level ];
    # group General information
    :global varSystemPlatform [ /system/resource/get value-name=platform ];
    :global varSystemBoard [ /system/resource/get value-name=board-name ];
    :global varSystemArchitecture [ /system/resource/get value-name=architecture-name ];
    :global varSystemFactorySoftware [ /system/resource/get value-name=factory-software ];
    :global varSystemSoftwareVersion [ /system/resource/get value-name=version ];
    # group Resource information
    :global varResUptime [ /system/resource/get value-name=uptime ];
    :global varResCPU [ /system/resource/get value-name=cpu ];
    :global varResCPUCount [ /system/resource/get value-name=cpu-count ];
    :global varResCPUFreq [ /system/resource/get value-name=cpu-frequency ];
    :global varResCPULoad [ /system/resource/get value-name=cpu-load ];
    :global varResHDDTotal [ /system/resource/get value-name=total-hdd-space ];
    :global varResHDDFree [ /system/resource/get value-name=free-hdd-space ];
    # group SNMP information
    :global varSNMPEnable [ /snmp/get value-name=enabled ];
    :global varSNMPContact [ /snmp/get value-name=contact ];
    :global varSNMPLocation [ /snmp/get value-name=location ];
    :global varSNMPEngineID [ /snmp/get value-name=engine-id ];

};


# [funcLogPrint $1 $2 $3]
#  Write log into device logs.
#  This function has three parameters with three option.
#  Exam: [funcLogPrint "info" "Notify" "This is notification"]
#  Note: Parameter_1 is Severity has three option "debug" "error" "info"
#  syntax [funcLogPrint $vinSeverity $vinName $vinMessage]
:set funcLogPrint do={

    # declare input variable
    :local vinSeverity [ :tostr $1 ];
    :local vinName     [ :tostr $2 ];
    :local vinMessage  [ :tostr $3 ];

    # declare local variable for process
    :local vstrLogMessage;

    :if ($vinSeverity ~ ("^(debug|error|info)\$")) do={
        :if ($vinSeverity = "debug") do={ 
            :set $vstrLogMessage ($vinName . ": " . $vinMessage);
            :log debug $vstrLogMessage; }
        :if ($vinSeverity = "error") do={ 
            :set $vstrLogMessage ($vinName . ": " . $vinMessage);
            :log error $vstrLogMessage; }
        :if ($vinSeverity = "info" ) do={ 
            :set $vstrLogMessage ($vinName . ": " . $vinMessage);
            :log info $vstrLogMessage; }
    } else={
        :set $vstrLogMessage $vinMessage;
        :log warning $vstrLogMessage; 
    }};


# [funcSoundAlert]
#  Set "beep" alarm by speaker on mainboard.
#  This function has one parameter with three options.
#  Exam: [funcSoundAlert "beep"]
#  Note: Parameter_1 has three option "beep" "warning" "alarm".
#  Syntax: [funcSoundAlert $strAlarm]
:set funcSoundAlert do={
    
    # declare input variable
    :local strAlarm [ :tostr $1 ];

    # process
    :if ($strAlarm = "alarm") do={ 
        # Adams Larm
        :for t1 from=1 to=10 step=1 do={
            :for t2 from=300 to=1800 step=40 do={
                :beep frequency=$t2 length=11ms;
                :delay 11ms;
            }
        }
        # SQUAWK Siren
        :for i from=1 to=3 step=1 do={
            :beep frequency=550 length=494ms;
            :delay 494ms;
            :beep frequency=400 length=494ms;
            :delay 494ms;
        }
     }
    :if ($strAlarm = "warning") do={ 
        # SQUAWK Phone 1
        :for t1 from=1 to=4 step=1 do={
            :for i from=1 to=10 step=1 do={
                :beep frequency=1195 length=22ms;
                :delay 22ms;
                :beep frequency=2571 length=22ms;
                :delay 22ms;
            }
        :delay 2000ms;
        }
     }
    :if ($strAlarm = "beep") do={
        # Adams Telefone
        :for t1 from=1 to=4 step=1 do={
            :for t2 from=1 to=25 step=1 do={
                :beep frequency=540 length=33ms;
                :delay 33ms;
                :beep frequency=650 length=27ms;
                :delay 27ms;
            }
        :delay 2000ms;
        }
    }
};


# [funcSendEmail]
#  Send message to Email with GlobalConfig.
#  Exam: [funcSendEmail "Notification: Hello! RouterOS"]
#  Note: The input message includes subject and body that separated by ":".
#        This function re-use [funcSplit].
#        This function is used to re-use for other functions.
#  Syntax: [funcSendEmail $strMessageText]
:set funcSendEmail do={

	# declare input variable
    :local strMessageText [ :tostr $1 ];

	# declare local / global variable for process
	:local strSubject;
	:local strBody;

	# declare for call global function 
	:global funcSplit;

	# process
	:if ($strMessageText != "nil") do={
		:set $strSubject [$funcSplit $strMessageText ":"];
		:set $strBody [$funcSplit $strMessageText ":" 1];
		[ :tool e-mail send to=$emailSendTo server=$emailSMTPserver port=$emailSMTPport tls=$emailUseTLS user=$emailUser password=$emailPassword from=$emailUser subject=$strSubject body=$strBody ];
    }
};


# [funcSendTelegram]
#  Send message to telegram with GlobalConfig.
#  Exam: [funcSendTelegram "Notification: Hello! RouterOS"]
#  Note: This function is used to re-use for other functions.
#  Syntax: [funcSendTelegram $strMessageText]
:set funcSendTelegram do={

    # declare input variable
    :local strMessageText [ :tostr $1 ];

    # declare local / global variable for process
    :global teleAPIToken;
    :global teleChatID;
    :local parseMode "html";
    :local disableWebPagePreview true;
    
    :local urlAPI "https://api.telegram.org/bot$teleAPIToken/sendMessage?chat_id=$teleChatID&text=$strMessageText&parse_mode=$parseMode&disable_web_page_preview=$disableWebPagePreview";

    # process
    :if ($strMessageText != "nil") do={
        #[ :tool fetch url=($urlAPI . $txtMessage) keep-result=no ];
        [ :tool fetch http-method=get url=$urlAPI keep-result=no ];
    }
};


# [funcSendWebhook]
#  Send message to webhook with GlobalConfig.
#  Exam: [funcSendWebhook "Notification: Hello! RouterOS"]
#  Note: This function is used to re-use for other functions.
#  syntax [funcSendWebhook $strMessageText]
:set funcSendWebhook do={

    # declare input variable
    :local strMessageText [ :tostr $1 ];

    # declare local / global variable for process
    :global urlwebhook;
    :local strHttpData "payload={\"text\":\"$strMessageText\"}";
    
    # process
    :if ($strMessageText != "nil") do={
        [ :tool fetch mode=https url=$urlwebhook  http-method=post  http-data=$strHttpData ];
    }
};


# [funcSendNotification]
#  Send notification alert to method that set in GlobalConfig.
#  Exam: [funcSendNotification "Notification: Hello! RouterOS"]
#  Note: This function re-use [funcSendEmail] [funcSendTelegram] and [funcSendWebhook].
#  Syntax: [funcSendNotification $strMessageText]
:set funcSendNotification do={

    # declare input variable
    :local strMessageText [ :tostr $1 ];
    
    # declare local / global variable for process

    # declare for call global function 
    :global arrSendNotify;
    :global funcSendEmail;
    :global funcSendTelegram;
    :global funcSendWebhook;

    # process
    :for i from=0 to=([:len $arrSendNotify] - 1) do={
      :if (($arrSendNotify->$i) = "email") do={
        $funcSendEmail ($strMessageText);
      }
      :if (($arrSendNotify->$i) = "telegram") do={
        $funcSendTelegram ($strMessageText);
      }
      :if (($arrSendNotify->$i) = "webhook") do={
        $funcSendWebhook ($strMessageText);
      }
    }
};


# [funcHealthCheck]
#  Run all process healthcheck then push notify if system has some problem.
#  Syntax: [funcHealthCheck]
:set funcHealthCheck do={

    # declare input variable

    # declare local / global variable for process
    :global varCustomName;
    :global varIdentity;
    :global varSystemID;
    :global arrWANname;
    :global arrWANinterface;
    :global arrWANnexthop;
    :global arrPSUname;
    :global arrPSUhealthID;
    :global arrPSUlaststatus;
    :global arrTemperature;
    :global arrTemperatureID;
    :global varResCPULoad;
    :global varResRamTotal;               # group Resource
    :global varResRamFree;                # group Resource
    :global varResHDDTotal;               # group Resource
    :global varResHDDFree;                # group Resource

    # declare for call global function 
    :global funcSendNotification;
    :global funcLogPrint;
    :global funcSoundAlert;

    # process
    # Check Wan
    :for i from=0 to=([:len $arrWANname] - 1) do={
      :local pingResult [:ping address=($arrWANnexthop->$i) interface=($arrWANinterface->$i) count=5];
      :if ($pingResult = 0) do={
        $funcSendNotification ("Alert: " . $varCustomName . " | " . $varIdentity . " | " . ($arrWANname->$i) . " has lost connection. Please check port: " . ($arrWANinterface->$i));
        $funcLogPrint error "funcCheckHealth" ("Alert: " . ($arrWANname->$i) . " has lost connection. Please check port: " . ($arrWANinterface->$i));
        $funcSoundAlert "beep";
      }
    }
    :delay 1500ms;
    # Check PSU
    :for i from=0 to=([:len $arrPSUhealthID] - 1) do={
      :local psuStatus [ /system/health/get value-name=value number=($arrPSUhealthID->$i) ];
      :if ($psuStatus != ($arrPSUlaststatus->$i)) do={
        :if ($psuStatus = "ok") do={
          $funcSendNotification ("Info: " . $varCustomName . " | " . $varIdentity . " | " . ($arrPSUname->$i) . " has been turned on.");
          :set ($arrPSUlaststatus->$i) "ok";
          $funcLogPrint error "funcCheckHealth" ("Info: " . ($arrPSUname->$i) . " has been turned on.");
          $funcSoundAlert "beep";
        } 
        :if ($psuStatus = "fail") do={
          $funcSendNotification ("Info: " . $varCustomName . " | " . $varIdentity . " | " . ($arrPSUname->$i) . " has been turned off.");
          :set ($arrPSUlaststatus->$i) "fail";
          $funcLogPrint error "funcCheckHealth" ("Info: " . ($arrPSUname->$i) . " has been turned off.");
          $funcSoundAlert "beep";
        }
      }
    }
    :delay 1500ms;
    # Check Performance
    # CPU >80
    :set $varResCPULoad [/system/resource/get cpu-load];
    :if ($varResCPULoad > 80) do={
        $funcSendNotification ("Alert: " . $varCustomName . " | " . $varIdentity . " | CPU is overloaded.");
        $funcLogPrint error "funcCheckHealth" ("Alert: CPU is overloaded.");
        $funcSoundAlert "warning";
    }
    # Memory <25
    :set $varResRamTotal [/system/resource/get total-memory];
    :set $varResRamFree [/system/resource/get free-memory];
    :if ((($varResRamFree * 100) / $varResRamTotal) < 25) do={
        $funcSendNotification ("Alert: " . $varCustomName . " | " . $varIdentity . " | RAM is overloaded.");
        $funcLogPrint error "funcCheckHealth" ("Alert: RAM is overloaded.");
        $funcSoundAlert "warning";
    }
    # Harddisk <35
    :set $varResHDDTotal ([/system/resource/get total-hdd-space] / 1000000);
    :set $varResHDDFree ([/system/resource/get free-hdd-space] / 1000000);
    :if ((($varResHDDFree * 100) / $varResHDDTotal) < 35) do={
        $funcSendNotification ("Alert: " . $varCustomName . " | " . $varIdentity . " | Storage is almost full.");
        $funcLogPrint error "funcCheckHealth" ("Alert: Storage is almost full.");
        $funcSoundAlert "warning";
    }
    # Temperature Alarm >75 | Warning >60
    :for i from=0 to=([:len $arrTemperatureID] - 1) do={
        :local tmpTemperature [ /system/health/get value-name=value number=($arrTemperatureID->$i) ];
        :if ($tmpTemperature > 75) do={
            $funcSendNotification ("Alarm: " . $varCustomName . " | " . $varIdentity . " | " . ($arrTemperature->$i) . " too high - " . $tmpTemperature . ".C");
            $funcLogPrint error "funcCheckHealth" ("Alarm: " . ($arrTemperature->$i) . "too high.");
            $funcSoundAlert "alarm";
        }
        :if (($tmpTemperature > 60) && ($tmpTemperature < 75)) do={
            $funcSendNotification ("Warning: " . $varCustomName . " | " . $varIdentity . " | " . ($arrTemperature->$i) . " too high - " . $tmpTemperature . ".C");
            $funcLogPrint error "funcCheckHealth" ("Warning: " . ($arrTemperature->$i) . "too high.");
            $funcSoundAlert "warning";
        }
    }
    # key log
    $funcLogPrint info "funcHealthCheck" "Completed Health Check.";
};
