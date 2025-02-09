# ------------------- HEADER -------------------------------------------
# RouterOS script: FunctionLibrary
# Copyright (c) 2024-2025 Quach Do Duy <quachdoduy@gmail.com>
#
# requires RouterOS, version=7.15.2
# Function library in global
#
# Created at 08/01/2025
# Please, keep this header if using this script. Thanks
# ------------------- END HEADER ---------------------------------------

# ==========================================
# GLOBAL CONFIGURATION THAT CAN BE CHANGED BY USER
# ==========================================

# Set correct customer name to notify correct information.
:global varCustomName "Crossian";

# ===== NOTIFICATION =====

# Set method for notification.
#  Currently there are only 3 notification methods, you can reduce it to only 1 method.
#  Exam:  :global arrSendNotify {"email";"telegram";"webhook"};
:global arrSendNotify {"email";"telegram";"webhook"};

    # Configure settings for each notification method
    # === EMAIL ===
    :global emailUser "device.monitor@gmail.com";
    :global emailPassword "3m@il-S3cr3t";
    :global emailSMTPserver "smtp.gmail.com";
    :global emailSMTPport "465";
    :global emailUseTLS "yes";
    :global emailSendTo {"quachdoduy@gmail.com";"qis.comp@gmail.com"};
    # === WEBHOOK ===
    :global urlwebhook "https://hook.eu2.make.com/w1wx4rvmgiy73lo0if4am2cb02wff162";
    # === TELEGRAM ===
    :global teleAPIToken "7048815678:AAFF_S1FdkabzvF3tD4ZlSvX9UNiAgDWjLQ";
    :global teleChatID "-6891844488";


# ===== HEALTH CHECK =====

# Set number of WANs 
#  In this case we have two Wans
#  Exam:  :global arrWANname {"WAN-1";"WAN-2"};
:global arrWANname {"WAN-1";"WAN-2"};

    # Configure setting of Wans
    # === Name of WANs ===
    #  This is name of interface that config as WAN
    #  Exam:  :global arrWANinterface {"pppoe-out1";"pppoe-out2"};
    :global arrWANinterface {"pppoe-out1";"pppoe-out2"};
    # === Nexthop of WANs ===
    #  This is Nexthop for check WANs status.
    #  Exam:  :global arrWANnexthop {"1.1.1.1";"2.2.2.2"};
    :global arrWANnexthop {"203.210.148.84";"203.210.148.84"};
    #  Proc: Script will check connection:
    #        From "WAN-1" has Interface name "pppoe-out1" to Nexthop "1.1.1.1"
    #        From "WAN-2" has Interface name "pppoe-out2" to Nexthop "2.2.2.2"

# Set number of PSUs
#  In this case we have two Power Source Unit
#  Exam:  :global arrPSUname {"PSU-1";"PSU-2"};
:global arrPSUname {"PSU-1";"PSU-2"};

    # Configure setting of PSUs
    #  Exam:  :global arrPSUhealthID {"SH_ID";"SH_ID"};
    #  Note:  SH_ID mean ID in System Health table, you can get it by use command [/system/health/ print]
    :global arrPSUhealthID {"8";"9"};

# Set number of Temperatures
#  In this case we have three Temperatures
#  Exam:  :global arrTemperature {"Board-Temperature";"CPU-Temperature";"Switch-Temperature"};
:global arrTemperature {"Board-Temperature";"CPU-Temperature";"Switch-Temperature"};

    # Configure setting of Temperatures
    #  Exam:  :global arrTemperatureID {"SH_ID";"SH_ID";"SH_ID"};
    #  Note:  SH_ID mean ID in System Health table, you can get it by use command [/system/health/ print]
    :global arrTemperatureID {"7";"0";"1"};
