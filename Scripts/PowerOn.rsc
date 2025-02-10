# =============== HEADER ===============
# RouterOS script: FunctionLibrary
# Copyright (c) 2024-2025 
#  Author: Quach Do Duy 
#  Email: <quachdoduy@gmail.com>
#  Git URL: /quachdoduy/Mikrotik-RouterOS-Script
# --------------------------------------
# Please, keep this header if using this script.
# ============= END HEADER =============

# declare for call global function 
:global funcHealthCheck;
:global funcSendNotification;
:global funcLogPrint;

# process
do {
    [ /system/script/run [find name=GlobalConfig]];
    [ /system/script/run [find name=GlobalFunction]];
    :delay 30s;
    $funcSendNotification ("Warning: Completed Power on");
    $funcLogPrint info "Power-On" "Completed Power on.";
    :delay 15s;
    $funcHealthCheck;
};