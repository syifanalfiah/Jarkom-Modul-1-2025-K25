nc 10.15.43.32 3404

http.request.uri contains ".doc" || http.request.uri contains ".pdf" || http.request.uri contains ".xls"

http.request.uri matches "\\.(exe|dll|bat|ps1|zip|doc|docx|pdf|vbs|sh|py)$"

tshark -r MelkorPlan2.pcap --export-objects http,all_files

ls -la all_files/

sha256sum knr.exe

KOMJAR25{M4ster_4n4lyzer_S9aSEQGXUAW8PIgLx62mAFdDi}