# Mikrotik-RouterOS-Script


[![GitHub stars](https://img.shields.io/github/stars/quachdoduy/Mikrotik-RouterOS-Script?logo=GitHub&style=flat&color=red)](https://github.com/quachdoduy/Mikrotik-RouterOS-Script/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/quachdoduy/Mikrotik-RouterOS-Script?logo=GitHub&style=flat&color=green)](https://github.com/quachdoduy/Mikrotik-RouterOS-Script/network)
[![GitHub watchers](https://img.shields.io/github/watchers/quachdoduy/Mikrotik-RouterOS-Script?logo=GitHub&style=flat&color=blue)](https://github.com/quachdoduy/Mikrotik-RouterOS-Script/watchers)
[![required RouterOS version](https://img.shields.io/badge/RouterOS-7.15.2-yellow?style=flat)](https://mikrotik.com/download/changelogs/)
[![donate with paypal](https://img.shields.io/badge/Like_it%3F-Donate!-orange?logo=githubsponsors&logoColor=orange&style=flat)](https://paypal.me/quachdoduy)
[![donate with buymeacoffe](https://img.shields.io/badge/Like_it%3F-Donate!-orange?logo=githubsponsors&logoColor=orange&style=flat)](https://buymeacoffee.com/quachdoduy)



Kịch bản (Script) này tôi viết trên hệ thống của công ty đối tác nhằm phục vụ mục đích vận hành hệ thống.

> 💡 Nếu bạn có bất kỳ ý tưởng nào về kịch bản hoặc bạn chỉ muốn chia sẻ ý kiến ​​của mình, bạn có thể [Thảo luận](https://github.com/quachdoduy/Mikrotik-RouterOS-Script/discussions/), hoặc bạn có thể mở một [Vấn đề](https://github.com/quachdoduy/Mikrotik-RouterOS-Script/issues) nếu bạn tìm thấy lỗi

## Ý tưởng ban đầu (Original idea)
- Tự động hóa tác vụ giám sát các kết nối WANs của thiết bị, cảnh báo đến Telegram và Slack.
- Viết kịch bản (Script) theo tư duy tập trung hóa và có thể tái sử dụng cho các kịch bản đơn nhỏ lẻ.

## Tính năng (Features)
- Thiết lập các kênh thông báo (có thể lựa chọn):
    - Thông báo qua Email: gửi cảnh bảo đến Email được thiết lập để nhận các cảnh báo.
    - Thông báo qua Telegram: gửi cảnh báo đến Telegram được thiết lập để nhận các cảnh báo.
    - Thông báo qua Webhook: gửi cảnh báo đến Webhook được thiết lập để nhận các cảnh báo. Webhook có tính phổ dụng cao vì có khá nhiều ứng dụng sử dụng Webhook như là 1 cổng đón nhận dữ liệu trước khi xử lý.
- Ghi lưu lại Log các thao tác thực hiện với thiết bị phục vụ truy vết sau.
- Kiểm tra tình trạng sửc khỏe hệ thống với các thông số:
    - Kiểm tra tình trạng kết nối các kênh WANs của thiết bị (WANs).
    - Kiểm tra tình trạng các kết nối nguồn điện của thiết bị (PSUs).
    - Kiểm tra tình trạng hiệu suất (Performance):
        - Năng lực bộ vi xử lý (CPUs): Cảnh báo khi Hiệu năng > 80%.
        - Dung lượng bộ nhớ tạm thời (RAMs): Cảnh báo khi mức sử dụng > 75%.
        - Dung lượng bộ nhớ trong (HDDs): Cảnh báo khi mức sử dụng > 65%.
        - Nhiệt độ bộ vi xử lý (CPUs) và bảng mạch chủ (Mainboard): Cảnh báo mức Warning với nhiệt độ từ 60-75 độ C. Cảnh báo mức Alarm với nhiệt độ cao hơn 75 độ C.
    - Tất cả các cảnh báo đều có kèm theo cảnh báo bằng âm thanh từ loa "beep" trên bảng mạch chủ.
- Khởi động thiết bị:
    - Thông báo quá trình khởi động thiết bị.
    - Thực hiện sao lưu cấu hình thiết bị.
    - Thực hiện khởi động thiết bị.

## Yêu cầu hệ thống (System requirements)

### Phần mềm (Software)

#### RouterOS
Kịch bản (script) này được viết trên Hệ điều hành RouterOS'7.n' (chính xác là RouterOS'7.15.2') nên cần kiểm tra tính tương thích ngược với hệ điều hành RouterOS'6.n' và thấp hơn.

#### Visual Code
Kịch bản (script) này được viết trên phần mềm Visual Code của Microsoft với phần mở rộng tương thích.
- [Visual Code](https://code.visualstudio.com/download)
- [Extensions](https://github.com/devMikeUA/vscode_mikrotik_routeros_script)

### Phần cứng (Hardware)
Kịch bản (script) có khả năng làm tăng kích thước mỗi lần cập nhật nên cần lưu ý với các thiết bị có dung lượng lưu trữ 16MB trở xuống.

Cấu hình cũng có khả năng tăng kích thước sau thời gian. Hẫn cẩn trọng và kiểm tra thường xuyên.

## Thiết lập ban đầu (Initial setup)

### Hẫy sẵn sàng (Get ready)!

