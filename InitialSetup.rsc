:do {
/system script
remove [find name=GlobalConfig]
add name=GlobalConfig owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source="

"
remove [find name=GlobalFunction]
add name=GlobalFunction owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source="

"
};