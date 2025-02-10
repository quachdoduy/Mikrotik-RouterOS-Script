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
# GLOBAL CONFIGURATION 
# THAT CAN BE CHANGED BY USER
# ==============================

# Set correct customer name to notify correct information.
:global varCustomName "Customer ABC XYZ";

# ===== NOTIFICATION =====

# Set method for notification.
#  Currently there are only 3 notification methods, you can reduce it to only 1 method.
#  Exam:  :global arrSendNotify {"email";"telegram";"webhook"};
:global arrSendNotify {"email";"telegram";"webhook"};

    # Configure settings for each notification method
    # === EMAIL ===
    :global emailUser "ABC.XYZ@gmail.com";
    :global emailPassword "3m@il-S3cr3t";
    :global emailSMTPserver "smtp.gmail.com";
    :global emailSMTPport "465";
    :global emailUseTLS "yes";
    :global emailSendTo {"quachdoduy@gmail.com";"qis.comp@gmail.com"};
    # === WEBHOOK ===
    :global urlwebhook "https://hook.eu2.make.com/BxUIxTMKl8bUSSE4AkJIm4VGXDHN8dsP";
    # === TELEGRAM ===
    :global teleAPIToken "0123456789:This_Is_Fake_API_Token_Telegram-xyz";
    :global teleChatID "-9876543210";

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
    :global arrWANnexthop {"8.8.8.8";"8.8.4.4"};
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

# ===== INSTALL CONFIG =====

# ===========================
# GLOBAL FUNCTION DECLARATION
# ===========================