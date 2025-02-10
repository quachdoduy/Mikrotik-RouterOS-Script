# =============== HEADER ===============
# RouterOS script: FunctionLibrary
# Copyright (c) 2024-2025 
#  Author: Quach Do Duy 
#  Email: <quachdoduy@gmail.com>
#  Git URL: /quachdoduy/Mikrotik-RouterOS-Script
# --------------------------------------
# Please, keep this header if using this script.
# ============= END HEADER =============

# declare local / global variable for process
:global varCustomName;
:global varIdentity;
:global varSystemID;

# declare for call global function 
:global funcSendNotification;
:global funcLogPrint;
:global funcSoundAlert;
:global funcGetDate;

# process
do {
    $funcSendNotification ("Info: " . $varCustomName . " | " . $varIdentity . " | " . $varSystemID . " in the process of rebooting for maintenance.");
    $funcLogPrint info "Reboot" ("Info: Rebooting for maintenance.");
    $funcSoundAlert "beep";
    $funcGetDate "YYYYMMDD";

    # backup config
    [ :export file=("config_" . $varSysDate . ".rsc") ];
    [ :delay 60s ];
    [ /system/reboot ];
};