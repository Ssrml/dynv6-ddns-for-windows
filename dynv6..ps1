
Function get_local_ipv4() {
    $(Invoke-WebRequest -UseBasicParsing -Uri ipv4.ip.sb).content.trim()
}

Function get_local_ipv6() {
    $(Invoke-WebRequest -UseBasicParsing -Uri ipv6.ip.sb).content.trim()
}

Function get_linux_ipv4([string]$user,[string]$ip,[int]$port,[string]$key,[string]$bin_type) {
    switch ($bin_type){
        curl {$bin = "curl -4 ip.sb" }
        wget {$bin = "wget -4 -O- ip.sb" }
        default{
            Write-Output "linux仅支持curl或者wget!"
            exit 1
        }
    }

    if ($key -eq $NULL -or $key -eq ""){
        ssh ${user}@${ip} -p $port $bin
    }else{ssh ${user}@${ip} -p $port -i $key $bin}
}

Function get_linux_ipv6([string]$user,[string]$ip,[int]$port,[string]$key,[string]$bin_type) {
    switch ($bin_type){
        curl {$bin = "curl -6 ip.sb" }
        wget {$bin = "wget -6 -O- ip.sb" }
        default{
            Write-Output "linux仅支持curl或者wget!"
            exit 1
        }
    }

    if ($key -eq $NULL -or $key -eq ""){
        ssh ${user}@${ip} -p $port $bin
    }else{ssh ${user}@${ip} -p $port -i $key $bin}
}

Function get_windows_ipv4([string]$user,[string]$ip,[string]$port,[string]$key){
   $bin ='powershell $(Invoke-WebRequest -UseBasicParsing -Uri ipv4.ip.sb).content.trim()'
    if ($key -eq $NULL -or $key -eq ""){
        ssh ${user}@${ip} -p $port $bin
    }else{ssh ${user}@${ip} -p $port -i $key $bin}
}


Function get_windows_ipv6([string]$user,[string]$ip,[string]$port,[string]$key){
    $bin ='powershell $(Invoke-WebRequest -UseBasicParsing -Uri ipv6.ip.sb).content.trim()'
     if ($NULL -eq $key -or $key -eq ""){
        ssh ${user}@${ip} -p $port $bin
     }else{ssh ${user}@${ip} -p $port -i $key $bin}

}

Function get_esxi_ipv4([string]$user,[string]$ip,[int]$port,[string]$key){
    if ($NULL -eq $key -or $key -eq ""){
        ssh ${user}@${ip} -p $port $bin
    }else{ssh ${user}@${ip} -p $port -i $key "wget -O- ipv4.ip.sb"}
    
}

Function get_esxi_ipv6([string]$user,[string]$ip,[int]$port,[string]$key){
    if ($NULL -eq $key -or $key -eq ""){
        ssh ${user}@${ip} -p $port $bin
     }else{ssh ${user}@${ip} -p $port -i $key "wget -O- ipv6.ip.sb"}
    
}

#------------------------------------
#更新zone记录
#------------------------------------
Function zone_ipv4_update([string]$common_zone,[string]$zone_ipv4,[string]$prev){  
    if( $zone_ipv4 -ne $prev ){
        if ($NULL -eq $dynv6_key -or $dynv6_key -eq ""){
            ssh api@${dynv6_server} "hosts $common_zone set ipv4addr $zone_ipv4"
        }else{
            if ($(ssh api@${dynv6_server} "echo") -eq "invalid command: echo"){exit 1}
            ssh api@${dynv6_server} -i "$dynv6_key" "hosts $common_zone set ipv4addr $zone_ipv4"}

    }else{Write-Output "Zone---:ipv4 Unchanged"}
    Write-Output "ipv4=$zone_ipv4" >> $iniFile.zone.history
}

Function zone_ipv6_update([string]$common_zone,[string]$zone_ipv6,[string]$prev){
    if ($zone_ipv6 -ne $prev){
        if ($NULL -eq $dynv6_key -or $dynv6_key -eq ""){
            ssh api@${dynv6_server} "hosts $common_zone set ipv6addr $zone_ipv6"
        }else{
            if ($(ssh api@${dynv6_server} "echo") -eq "invalid command: echo"){exit 1}
            ssh api@${dynv6_server} -i "$dynv6_key" "hosts $common_zone set ipv6addr $zone_ipv6 "}
    }else{Write-Output "Zone---:ipv6 Unchanged"}
    Write-Output "ipv6=$zone_ipv4" >> $iniFile.zone.history 
}
function 皮一下 {
    
    $颜文字='EDBKVUpVETAgACAAIAAgACAAIAB3ACgAPwAUBD8AKQB3AA0ACgAvAG4AEDDmZDx36mwRMCAAIAAgACAAKADOMHgw4/8BMCkADQAKAC8AbgAQMA1OUVwRMCAAIAAgACAAIAAgACgA4/9fACwA4/8gACkADQAKAC8AbgAQMH1ZNoARMCAAIAAgACAAIAAgAP0wKAA/AD8AvSU/ACkAzjANAAoALwBuABAw0mgRMCAAIAAgACAAIAAgACgAPwA/AD8APwA/AD8AKQA/AD8ADQAKAC8AbgAQML1iETAgACAAIAAgACAAIAAoAOP/tQMoACMA4/8pAAYmcCVuJW8AKADj/7924/8vAC8ALwApAA0ACgAvAG4AEDCyThEwIAAgACAAIAAgACAACP9lMOP/MwDj/wn/ZTBtJV7/DQAKAC8AbgAQMFdsETAgACAAIAAgACAAIACjAygAIACwACAAsyUgALAAfAB8AHwAKQA0/g0ACgAvAG4AEDAoexEwIAAgACAAIAAgACAAKABe/+P/KABPAE8AKQDj/ykA1jANAAoALwBuABAw5mQRMCAAIAAgACAAIAAgAPhRKAB5gr92eYIgACkADQAKAC8AbgAQMHVVdVURMCAAIAAgACAAIAAgACgAKgAgAOP/MwApACgAtQPj/yAAKgApAA0ACgAvAG4AEDAWYzufTlwRMCAAIAAgACAAIAAgACgAKgDj/3IA0gHj/ykADQAKAA0ACgAQMPdVETAgACAAIAAgACAAIAAXJXwAQP9PADIgfAAbJSAA91V+AH4ADQAKAA0ACgAQMN6YETAgACAAIAAgACAAIAA//igA4/82/uP/KQA//g0ACgANAAoAEDB9WfRuETAgACAAIAAgACAAIAAoAHUAPwA/AHUAPwA/ACkADQAKAA0ACgAQMGgAaQARMCAAIAAgACAAIAAgAEgAaQB+ACAAbwAoACoA4/+9JeP/KgApANYwDQAKAA0ACgAQMGZVZlURMCAAIAAgACAAIAAgAD8AKABeAD8AXgAqACkADQAKAA0ACgAQMM1iTGgRMCAAIAAgACAAIAAgAG8AKAAqAGcivSVmIikAxDAPJQElEyUNAAoADQAKABAwymCcVREwIAAgACAAIAAgACAAcCUoACoAsAC9JbAAKgApAG8lDQAKAA0ACgAQMB9WNFYRMCAAIAAgACAAIAAgAAj/yyVA/yAAMwAyIMslCf8NAAoADQAKABAwVk4RMCAAIAAgACAAIAAgAG8AKAAqAF4AIP9eACoAKQBvAA0ACgANAAoAEDCCVREwIAAgACAAIAAgACAAKAAjAGAATwAyICkADQAKAA0ACgAQMCNhT08RMCAAIAAgACAAIAAgACgAsAD8MLAAAzApAA0ACgAvAG4AEDA+ZUFcETAgACAAIAAgACAAIADLJXwA4/98AF8AIAA9ADMADQAKAC8AbgAQMPxU/FQRMCAAIAAgACAAIAAgAG8AKADj/9gw4/9vAAP/KQANAAoALwBuABAw71N2YBEwIAAgACAAIAAgACAACP8d/wIwHf8J/w0ACgANAAoAEDAHUhEwIAAgACAAIAAgACAAfgB+ACgAIABB/iAAQf4gACkAIAB+AH4AfgANAAoALwBuABAwu1MRMCAAIAAgACAAIAAgACgA/DD8MJswKQANAAoALwBuABAwH3UUbBEwIAAgACAAIAAgACAAKAD8MGAAMiD8MCkADQAKAA0ACgAQMChg9V8RMCAAIAAgACAAIAAgAG8AKAAATj/+AE4rACkAbwANAAoADQAKABAwKV2DbhEwIAAgACAAIAAgACAAbwAoAGci41NmIikAbwANAAoADQAKABAwDU4vZhFiETAgACAAIAAgACAAIAAfMSgAIACUJSwAIACUJSAAKQAPMQ0ACgAvAG4AEDAljYZOETAgACAAIAAgACAAIAAoAG8AXwAgAF8AKQA/AA0ACgAvAG4AEDBDVENUQ1QRMCAAIAAgACAAIAAgACgAmSJP/pkiKQANAAoALwBuABAwB1IRMCAAIAAgACAAIAAgACgAyQK9JeP/Xv8pACAAB1J+AH4ADQAKAA0ACgAQMOBlAIoRMCAAIAAgACAAIAAgAAj/Cv/j/wj/qDAJ/+P/Cf8NAAoADQAKABAwSmRLYhEwIAAgACAAIAAgACAAESUoAOP/FAQgAOP/KQANJQ0ACgANAAoAEDANTsJhETAgACAAIAAgACAAIAAoACD/XwAg/zsAKQANAAoADQAKABAwRlQRMCAAIAAgACAAIAAgAAElMyUBJQAwASUzJQElDQAKAA0ACgAQMHZinZgRMCAAIAAgACAAIAAgACgABiYyIMp2YAApAGMADQAKAA0ACgAQMOdWETAgACAAIAAgACAAIAAI/zIgFARgAAn/DQAKAA0ACgAQMJViTZYRMCAAIAAgACAAIAAgABclKAAgAFQAT/5UACAAKQAbJQ0ACgANAAoAEDARYhmVhk4RMCAAIAAgACAAIAAgACgAAjBP/gIwKgApAA0ACgANAAoAEDC1VR9muk4RMCAAIAAgACAAIAAgACgAIAA9AD8AyQM/AD0AIAApAG0ADQAKAA0ACgAQMLVVXFQRMCAAIAAgACAAIAAgACAAIAAgACAAYSLJA2EiDQAKAA0ACgAQMIpxETAgACAAIAAgACAAIAAoACoA4/8oAKgwKQDj/ykADQAKAA0ACgAQMLNbnn8RMCAAIAAgACAAIAAgACgAPwA/AD8APwApAA0ACgANAAoAEDA4gaJ+ETAgACAAIAAgACAAIAAoACoALwDJAzz/KgApAA0ACgANAAoAEDBcVFxUXFQRMCAAIAAgACAAIAAgAC0lLiVP/i0lLiUNAAoADQAKABAw3GLcYhEwIAAgACAAIAAgACAA/jAoAOP/vSXj/ykAQgB5AGUAfgBCAHkAZQB+AA0ACgANAAoAEDCcZTx3ETAgACAAIAAgACAAIAAoACAAQf4gAEH+IAApACAAfgCSIQ0ACgANAAoAEDCOf3NUETAgACAAIAAgACAAIACoAygA4/8/AOP/KQCoAw0ACgANAAoAEDDqlREwIAAgACAAIAAgACAAPwAoAD8AIAA/ACAAPwA/ACkADQAKAA0ACgAQMOFtmlsRMCAAIAAgACAAIAAgAAElKADj//ww4/8qAHwAfAB8AAElASUNAAoADQAKABAwKlnvUxVghk4RMCAAIAAgACAAIAAgAP0wKAAqAAIwPgAUBDwAKQBvAJwwDQAKAA0ACgAQMFBgFmARMCAAIAAgACAAIAAgAAwlKAACMBQEAjApABAlDQAKAA0ACgAQMG8AcgB6ABEwIAAgACAAIAAgACAAyyV8AOP/fABfAA0ACgANAAoAEDBnAG8AbwBkABEwIAAgACAAIAAgACAAbwAoAOP/vSXj/ykARP8NAAoADQAKABAwJE/DXxEwIAAgACAAIAAgACAAKAAb/zIgEiNgACkADQAKAA0ACgAQMN981XwRMCAAIAAgACAAIAAgAFgAT/5YAA0ACgANAAoAEDAjV96LETAgACAAIAAgACAAIAAqADwAfAA6AC0AKQAgAA0ACgANAAoAEDDSaBEwIAAgACAAIAAgACAAKAA/AD8APwA/AD8APwApAD8APwANAAoADQAKABAwBnIRexEwIAAgACAAIAAgACAA/jAoAGcivSVmIioAKQBvAA0ACgAvAG4AEDBiAGkAbgBnAG8AETAgACAAIAAgACAAIAAoAG8AnDC9JZwwKQBvAAYmWwBCAEkATgBHAE8AIQBdAA0ACgANAAoAEDCXX190ETAgACAAIAAgACAAIABe/ygA4/+9JeP/Xv8pACgAXv/j/70l4/8pAF7/DQAKAA0ACgAQMJdfD2ERMCAAIAAgACAAIAAgADwAKADj/zb+4/8pAD4ADQAKAC8AbgAQMO9V6lQRMCAAIAAgACAAIAAgAO9VfgAgAG8AKAAqAOP/vSXj/yoAKQBvAA0ACgANAAoAEDDemBEwIAAgACAAIAAgACAAP/4oAOP/Nv7j/ykAP/4NAAoADQAKABAwDlYOVhEwIAAgACAAIAAgACAADv88AHsAPQAO/w7/Dv8O/wj/DlZ+AA5WfgAOVn4ACf8NAAoADQAKABAwcl5vZxEwIAAgACAAIAAgACAAKADj/70l4/8pAF7/oCVyXm9noSVe/ygA4/+9JeP/KQANAAoADQAKABAw2Jp0UREwIAAgACAAIAAgACAAxgMoAJwwvSWcMCoAKQA/AA0ACgANAAoAEDDfjWBP9IsRMCAAIABwJSgA4/+9JeP/KQBtJQ0ACgANAAoAEDBnAG8AETAgACAAIAAgACAAIAA8ACgA4/82/uP/KQBbAEcATwAhAF0ADQAKAA0ACgAQMGcAbwBvAGQAETAgACAAIAAgACAAIABvACgA4/+9JeP/KQBE/w0ACgANAAoAEDDIVMhUyFTIVBEwIAAgACAAIAAgACAAKgAyID8AYAApADIgPwBgACkAKgAyID8AYAApACoAMiA/AGAAKQANAAoADQAKABAw6FURMCAAIAAgACAAIAAgACgAPwA/AD8APwApAD8APwANAAoADQAKABAw6FURMCAAIAAgACAAIAAgAP4wKABnIj8AZiIqACkAnTANAAoALwBuABAwfVn0bhEwIAAgACAAIAAgACAAKAB1AD8APwB1AD8APwApAA0ACgAvAG4AEDB9WfRuETAgACAAIAAgACAAIAAI/5wwvSU+/yoACf8J/w0ACgAvAG4AEDB9WQBfw18RMCAAIAAgACAAIAAgACgAKgBeAL0lXgAqACkADQAKAC8AbgAQMH1ZNoARMCAAIAAgACAAIAAgAP0wKAA/AD8AvSU/ACkAzjANAAoALwBuABAwaABhAHAAcAB5ABEwIAAgACAAIAAgACAAKAAyIL0lYAA/AD8APwApAA0ACgANAAoAEDBoAGkAETAgACAAIAAgACAAIABIAGkAfgAgAG8AKAAqAOP/vSXj/yoAKQDWMA0ACgANAAoAEDBoAGkAYQBoAGkAYQARMCAAIAAgACAAIAAgAMslKAAgAD7/v3Y+/ykAYzBIAGkAYQBoAGkAYQBoAGkAYQAmIA0ACgANAAoAEDBoAGkAZwBoABEwIAAgACAAIAAgACAAKAAoACAAeDAoAHgwMiA/AGAAKQB4MA0ACgANAAoAEDA8VDxUETAgACAAIAAgACAAIABeAE8AXgANAAoADQAKABAwImvOjxEwIAAgACAAIAAgACAAKAAgAD7/PwA+/wn/D/8ia86PPP8oACAAPv8/AD7/Cf8NAAoALwBuABAwt4PcgBEwIAAgACAAIAAgACAA/jAoAOP//DDj/ykAWAAoAF4AvSVeACkAnjANAAoADQAKABAwymCcVREwIAAgACAAIAAgACAAcCUoACoAsAC9JbAAKgApAG8lDQAKAC8AbgAQMMpgnFURMCAAIAAgACAAIAAgAJkivSWZIg0ACgANAAoAEDD7UYxjETAgACAAIAAgACAAIAAoACAA4//8MOP/KQC6TigAXgC9JV4AIAApAA0ACgANAAoAEDBhU8libwBrABEwIAAgACAAIAAgACAALgAuAC4AxgMoADAA4/8qACkAZlVmVWZVXwDGAygAKgDj/zAA4/8pADIgDQAKAA0ACgAQMGsATGsRMCAAIAAuAC4ALgDGAygAMADj/yoAKQBmVWZVZlVfAMYDKAAqAOP/MADj/ykADQAKAC8AbgAQMABfw18RMCAAIAAgACAAIAAgACgAKgBeAL0lXgAqACkADQAKAC8AbgAQMGZVZlURMCAAIAAgACAAIAAgAD8AKABeAD8AXgAqACkADQAKAC8AbgAQMFBOETAgACAAIAAgACAAIAAoAD8AMiA/AGAAPwApAA0ACgANAAoAEDBQThEwIAAgACAAIAAgACAAxgMoAGciyQNmIioAKQA/AA0ACgANAAoAEDBQTnVUETAgACAAIAAgACAAIAAoAGciPwBmIikAnjANAAoALwBuABAw4W6zjREwIAAgACAAIAAgACAAKAA/AMkCPwDJAj8AKQANAAoADQAKABAw4W6zjREwIAAgACAAIAAgACAAbwAoACoA4/82/uP/KgApAG8ADQAKAA0ACgAQMKlUyFTIVBEwIAAgACAAIAAgACAAPAAoACoA4/+9JeP/KgApAC8ADQAKAA0ACgAQMG8AaAB5AGUAYQBoABEwIAAgACAAIAAgACAAtQMoACoAMiA/AD8APwBA/ykANwQ/AA0ACgAvAG4AEDDmVOZUETAgACAAIAAgACAAIAAI/2ciMABmIgn/LwAvAAj/LQBfAC0AAjAJ/z8APwA/AA0ACgAvAG4AEDBiVjaAETAgACAAIAAgACAAIAAoAAAwPwA/AD8AKQAgAD8APwANAAoADQAKABAwYlY2gBEwIAAgACAAIAAgACAAKABeACYAXgApAC8ADQAKAA0ACgAQMM1iS2IRMCAAIAAgACAAIAAgAB0gHSBcACgA4//8MOP/KQAgACgA4//8MOP/KQAvAC8AHSAdIA0ACgANAAoAEDDNYkxoETAgACAAIAAgACAAIABvACgAKgBnIr0lZiIpAMQwDyUBJRMlDQAKAC8AbgAQMNiYETAgACAAIAAgACAAIAAoAF7/4/+9JeP/KQBe/w0ACgAvAG4AEDDYmNiYNnERMCAAIAAgACAAIAAgAD/+KADj/zb+4/8pAD/+DQAKAC8AbgAQMFdWETAgACAAIAAgACAAIAAoAC8AZyK9JWYiKQAvAA0ACgANAAoAEDAfZ4VfETAgACAAIAAgACAAIAAoAAYmvSUGJikADQAKAA0ACgAQMGNlsYIRMCAAIAAgACAAIAAgACoABSYsALAAKgA6AC4ABiYoAOP/vSXj/ykALwAkADoAKgAuALAABSYqACAAAjANAAoAEDDqlREwIAAgACAAIAAgACAAPwAoAD8AIAA/ACAAPwA/ACkADQAKAA0ACgAQMCpZ0miGThEwIAAgACAAIAAgACAAHzEoAGcixyVmIikADzENAAoALwBuABAwA5ARMCAAIAAgACAAIAAgAP0wKAA/AD8APwAqACkAPwABJQElASU/AD8ADQAKAA0ACgAQMHaWiZERMCAAIAAgACAAIAAgACgAIAAqAD7+vSU+/ikADQAKAC8AbgAQMHQAaAB4ABEwIAAgACAAIAAgACAABiYSIygAKgA+/y0AnDApAHYAIABUAEgAWAAhACEADQAKAC8AbgAQMClZSlURMCAAIAAgACAAIAAgAD8AKAAyID8AYAAqACkADQAKAC8AbgAQMAdOgVwRMCAAIAAgACAAIAAgAAH/KgAFJiwAsAAqADoALgAGJigA4/+9JeP/KQAvACQAOgAqAC4AsAAFJioAIAANAAoADQAKABAwEWLeVmVnZlURMCAAIAAgACAAIAAgAHwAfAD9MCgAKgDj/70l4/8qACkAzjDfMHwALgQNAAoADQAKABAwEWJlZ4ZOETAgACAAIAAgACAAIAB+ACgAXv/j/70l4/8pAF7/DQAKAC8AbgAQMHRRS1kRMCAAIAAgACAAIAAgACgAcABnIncAZiJxACkADQAKAA0ACgAQMHhej3kRMCAAIAAgACAAIAAgAG8AKAAqAOP/vSXj/yoAKQBvAA0ACgANAAoAEDA2gBEwIAAgACAAIAAgACAAKAA+/w3/Pv8pAFYADQAKABAw31QRMCAAIAAgACAAIAAgACgAPv81/z7/KQDOMH4AOf8v/w0ACgANAAoAEDAJZ4ZOETAgACAAIAAgACAAIAAoAG8AnDC9JZwwKQBvAAYmDQAKABAwXo0RMCAAIAAgACAAIAAgACgAKAAoAG8AKAAqAD8AvSU/ACoAKQBvACkAKQApAA0ACgANAAoAEDCobREwIAAgACAAIAAgACAAKADj/zb+4/8pAA0ACgANAAoAEDAvY0tZETAgACAAIAAgACAAIAAoAG8APgC1AygAbwA+AFX/KABnIikiZiIpAA0ACgAvAG4AEDAfd31ZETAgACAAIAAgACAAIABvACgAXgC9JV4AKQBvAA0ACgANAAoAEDD3VREwIAAgACAAIAAgACAA/jAoAGciTwBmIikAAzD3VX4ADQAKAC8AbgAQMPdVETAgACAAIAAgACAAIAAXJXwAQP9PADIgfAAbJSAA91V+AH4ADQAKAA0ACgAQMGiIETAgACAAIAAgACAAIAA8ACgA4/8zAOP/KQA+ACAAaIgB/w0ACgANAAoAEDBtjhEwIAAgACAAIAAgACAAKAAgACoA4/+9JeP/KQAoACgAZyI2/mYiKgApAA0ACgANAAoAEDBJe0l7ETAgACAAIAAgACAAIAAuAC4ALgAoACoA4/8Q/+P/KQDOMFsASXtJexFiJiBdAA0ACgAvAG4AEDB9We9TMXIRMCAAIAAgACAAIAAgAAj/KgA+/y0APv8qAAn/DQAKAA0ACgAQMO9TMXIRMCAAIAAgACAAIAAgAG4AKAAqAGcivSVmIioAKQBuAA0ACgANAAoAEDBWUwyEETAgACAAIAAgACAAIAA9AOP/yQPj/z0ADQAKABAwH3fSVBEwIAAgACAAIAAgACAAbwAoABwgvSUdICkAbwANAAoAEDBKVUpVETAgACAAIAAgACAAIAAv/ygAZyLjU2YiKQAv/w0ACgANAAoAEDBGVN5uETAgACAAIAAgACAAIAAoAOP/syXj/xv/KQANAAoADQAKABAwymARMCAAIAAgACAAIAAgACgAmSI/AJkiKQANAAoALwBuABAwymARMCAAIAAgACAAIAAgAKMDKABjMCAAsAAUBCAAsAA7ACkAYzANAAoADQAKABAwymCcVREwIAAgACAAIAAgACAAcCUoACoAsAC9JbAAKgApAG8lDQAKAC8AbgAQMHVVdVURMCAAIAAgACAAIAAgACgAKgAgAOP/MwApACgAtQPj/yAAKgApAA0ACgANAAoAEDDemDtUETAgACAAIAAgACAAIAAoACoA4/8zAOP/KQBtJQ0ACgANAAoAEDCyTrJOETAgACAAIAAgACAAIABvACgAKgDj/zMA4/8pAG8ADQAKAC8AbgAQMAZyNFkRMCAAIAAgACAAIAAgAIQlO/47JTMlUCUATiYgJiAgAAYmCP8+AMslPAAJ/w0ACgAQMA1OAF/DXxEwIAAgACAAIAAgACAA4/94MOP/DQAKABAwDU7hbhEwIAAgACAAIAAgACAAKAAqAOP/P/7j/ykADQAKABAwDU7hbhEwIAAgACAAIAAgACAACP8D/+P/Xv/j/wP/Cf8NAAoAEDANTj1yETAgACAAIAAgACAAIAAoACoAIADj/z/+4/8pAA0ACgAQMA1OgYlKVREwIAAgACAAIAAgACAA/TAI/2cioSVmIgn/zjANAAoAEDDmZBEwIAAgACAAIAAgACAA+FEoAHmCv3Z5giAAKQANAAoAEDD8VPxUETAgACAAIAAgACAAIABvACgA4//YMOP/bwAD/ykADQAKABAwQ1RDVENUETAgACAAIAAgACAAIAAoAJkiT/6ZIikADQAKABAwoWyeUtVsETAgACAAIAAgACAAIABuJQj/byU//3AlCf9tJQ0ACgAQMOBlSFkRMCAAIAAgACAAIAAgAG4lKABvJb0lcCUpAG0lDQAKABAw2JjHjxEwIAAgAC4ALgAuAC4ALgAoACgALwAtACAALQApAC8ADQAKAFpOKABgAO4wPwAgAD8ATQQpAC0EDQAKAFpOIAAoAF4AyQNeACAAPwBNBCkALQR9WamUEWKsVA0ACgAoACAAPwA/AAIwPwBNBCkALQQJTglOCU4JTgAwWk4NAAoAKADHAskDxwIgAD8ATQQpAC0ECU4JTglOCU4AMFpODQAKAHZR1k4NAAoAKAAgAD8AwQNgACkADQAKAMMDKAAgAD8AIAApAA0ACgAoACAAPwDAAwIwKQANAAoAPwApAD8APwANAAoAVQA/AKcwPwAqAFUADQAKAC8AKAAgAD8APwA/AD8AIAApAFwADQAKACgAEXspAA0ACgAoAFdsKQANAAoAKADjbCkADQAKACgA5oIReykADQAKAAMl+5bxZwMlDQAKAA=='

#[Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($aa))
$颜文字=[Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($颜文字)) -split "
"
Write-Output $颜文字[$(Get-Random -minimum 0 -maximum 321)]
}

Function host_ipv4_update([string]$common_zone,[string]$record,[string]$ip,[string]$prev){
    if ($ip -ne $prev) {
        if ($NULL -eq $dynv6_key -or $dynv6_key -eq ""){
            ssh api@${dynv6_server} "hosts $common_zone records set $record a addr $ip"
        }else{ssh api@${dynv6_server} -i "$dynv6_key" "hosts $common_zone records set $record a addr $ip"}

    }else{Write-Output "ipv4 Unchanged"}
    Write-Output "ipv4=$ip" >> $5_

}
Function host_ipv6_update([string]$common_zone,[string]$record,[string]$ip,[string]$prev){
    if ($ip -ne $prev){
        if ($NULL -eq $dynv6_key -or $dynv6_key -eq ""){
            ssh api@${dynv6_server} "hosts $common_zone records set $record aaaa addr $ip"
        }else{ssh api@${dynv6_server} -i "$dynv6_key" "hosts $common_zone records set $record aaaa addr $ip"}

    }else{Write-Output "ipv6 Unchanged"}
    Write-Output "ipv6=$ip" >> $5_
    
}

#------------------------------------
#找不到原作者了，只记得是从评论里复制的
#------------------------------------
function Get-IniFile 
{  
    param(  
        [parameter(Mandatory = $true)] [string] $filePath  
    )
$anonymous = "NoSection"
$ini = @{}  
    switch -regex -file $filePath  
    {  
        "^\[(.+)\]$" # Section  
        {  
            $section = $matches[1]  
            $ini[$section] = @{}  
            $CommentCount = 0  
        }
"^(;.*)$" # Comment  
        {  
            if (!($section))  
            {  
                $section = $anonymous  
                $ini[$section] = @{}  
            }  
            $value = $matches[1]  
            $CommentCount = $CommentCount + 1  
            $name = "Comment" + $CommentCount  
            $ini[$section][$name] = $value  
        }
"(.+?)\s*=\s*(.*)" # Key  
        {  
            if (!($section))  
            {  
                $section = $anonymous  
                $ini[$section] = @{}  
            }  
            $name,$value = $matches[1..2]  
            $ini[$section][$name] = $value  
        }  
    }
return $ini  
}

$iniFile = Get-IniFile .\dynv6.conf
$dynv6_server=$iniFile.zone.dynv6_server
$dynv6_key=$iniFile.zone.dynv6_key


if ($iniFile.zone.history -ne "" -or $null -ne $iniFile.zone.history){  
    if($(Test-Path -Path $iniFile.zone.history -PathType Container) -eq $True) {
        Write-Output "${iniFile.zone.history} is a DIR"
        exit 1
    }else{
        $ls_=Get-iniFile $iniFile.zone.history
        Write-Output "Data=test" > $iniFile.zone.history
         if ($(Get-Content $iniFile.zone.history) -ne "Data=test"){
             Write-Output "!!!Cannot write/read history file!!!"
            exit 1
        }
        
        $history_file=$ls_
        Write-Output "[zone]" > $iniFile.zone.history
    }
}



Write-Output "--------------------------------"
Write-Output "ddns log at $(Get-Date)"
Write-Output "zone update begin:"

#-----ZONE记录-----


if($iniFile.zone.port -eq "" -or $iniFile.zone.port-eq $null){$4_="22"}else{$4_=$iniFile.zone.port}
Switch($iniFile.zone.use_ipv4){ 
    "true"{
        Write-Output "Zone---:type is $($iniFile.zone.type)"
        Switch($iniFile.zone.type){
            local{
                    $1_= get_local_ipv4
                    Write-Output ":ipv4=${1_}"
                    Write-Output ":prev_ipv4=$($history_file.zone.ipv4)"
                    zone_ipv4_update $iniFile.zone.zone $1_ $history_file.zone.ipv4
                }
            windows{
                $1_ = get_windows_ipv4 $iniFile.zone.user $iniFile.zone.ip $4_ $iniFile.zone.key 
                    Write-Output ":ipv4=${1_}"
                    Write-Output ":prev_ipv4=$($history_file.zone.ipv4)"
                    zone_ipv4_update $iniFile.zone.zone $1_ $history_file.zone.ipv4
                }
            linux{
                $1_ = get_linux_ipv4 $iniFile.zone.user $iniFile.zone.ip $4_ $iniFile.zone.key $iniFile.zone.command_type
                    Write-Output ":ipv4=$1_"
                    Write-Output ":prev_ipv4=$($history_file.zone.ipv4)"
                    zone_ipv4_update $iniFile.zone.zone  $1_ $history_file.zone.ipv4
                
                }
            esxi{
                $1_ = get_esxi_ipv4 $iniFile.zone.user $iniFile.zone.ip $4_ $iniFile.zone.key 
                    Write-Output ":ipv4=$1_"
                    Write-Output ":prev_ipv4=$($history_file.zone.ipv4)"
                    zone_ipv4_update $iniFile.zone.zone $1_ $history_file.zone.ipv4
                }
            default {Write-Output ":Unknow type!"}
        }
    }
}

#Zone ipv6
Switch($iniFile.zone.use_ipv6){ 
    "true"{
        Write-Output "Zone（6）---:type is $($iniFile.zone.type) "
        Switch($iniFile.zone.type){
            local{

                    $1_= get_local_ipv6
                    Write-Output ":ipv6=$1_"
                    Write-Output ":prev_ipv6=$($history_file.zone.ipv6)"
                    zone_ipv6_update $iniFile.zone.zone $1_ $history_file.zone.ipv6

                }
            windows{
                $1_ = get_windows_ipv6 $iniFile.zone.user $iniFile.zone.ip $4_ $iniFile.zone.key 
                    Write-Output ":ipv6=$1_"
                    Write-Output ":prev_ipv6=$($history_file.zone.ipv6)"
                    zone_ipv6_update $iniFile.zone.zone $1_ $history_file.zone.ipv6
                }
                
            linux{
                $1_ = get_linux_ipv6 $iniFile.zone.user $iniFile.zone.ip $4_ $iniFile.zone.key $iniFile.zone.command_type
                    Write-Output ":ipv6=$1_ "
                    Write-Output ":prev_ipv6=$($history_file.zone.ipv6)"
                    zone_ipv6_update $iniFile.zone.zone  $1_ $history_file.zone.ipv6
                }
            esxi{
                $1_ = get_esxi_ipv6 $iniFile.zone.user $iniFile.zone.ip $4_ $iniFile.zone.key 
                    Write-Output ":ipv6=$1_"
                    Write-Output ":prev_ipv6=$($history_file.zone.ipv6)"
                    zone_ipv6_update $iniFile.zone.zone $1_ $history_file.zone.ipv6
                }
            default {Write-Output ":Unknow type!"}
            
        }
    }
}

#-----HOST记录-----
Write-Output "zone update end."
Write-Output "=================================="
Write-Output "hosts update start."

#烂代码，保留zone和历史文件位置
$ls_=$iniFile.zone.zone
$5_ = $iniFile.zone.history
$iniFile.Remove("zone")
Write-Output $iniFile.Keys
Write-Output ""
foreach($1_ in $iniFile.Keys)
{
    Write-Output "For [$1_]"
    if($iniFile[$1_].port -eq "" -or $iniFile[$1_].port -eq $null){$4_ = "22"}else{$4_ = $iniFile[$1_].port}
    Write-Output "[$1_]" >> $5_
    switch ($($iniFile[$1_].type)) {
        esxi{
            Test-Connection -Count 2 $iniFile[$1_].ip
            if ($? -eq $false) {
                Write-Output "ESXI offline"
            }else{
                
                if ($iniFile[$1_].use_ipv4 -eq "true"){
                    if ($($history_file.Keys -ccontains $1_) -ne $true ) {$3_ = ""}else{$3_ = $history_file[$1_].ipv4}
                    $2_ = $(get_esxi_ipv4 $iniFile[$1_].user $iniFile[$1_].ip $4_ $iniFile[$1_].key $iniFile[$1_].command_type)
                    Write-Output "ipv4=$2_"
                    Write-Output "prev_ipv4=$3_"
                    host_ipv4_update $ls_ $iniFile[$1_].name $2_ $3_ 

                }
                if ($iniFile[$1_].use_ipv6 -eq "true") {
                    if ($($history_file.Keys -ccontains $1_) -ne $true){$3_ = ""}else{$3_ = $history_file[$1_].ipv6}
                    $2_ = $(get_esxi_ipv6 $iniFile[$1_].user $iniFile[$1_].ip $4_ $iniFile[$1_].key $iniFile[$1_].command_type)
                    Write-Output "ipv6=$2_"
                    Write-Output "prev_ipv6=$3_"
                    host_ipv6_update $ls_ $iniFile[$1_].name $2_ $3_ 
                }
            }
        } 
        local{
            if ($iniFile[$1_].use_ipv4 -eq "true") {
                if ($($history_file.Keys -ccontains $1_) -ne $true){$3_ = ""}else{$3_ = $history_file[$1_].ipv4}
                if ($3_ -ne $(get_local_ipv4)){
                    Write-Output "ipv4=$(get_local_ipv4)" >> $5_
                    host_ipv4_update $ls_ $iniFile[$1_].name $(get_local_ipv4) $3_ 
                }
            }
            if ($3_ -eq "true") {
                if ($($history_file.Keys -ccontains $1_) -ne $true){$3_ = ""}else{$3_ = $history_file[$1_].ipv6}
                if ($3_ -ne $(get_local_ipv6)){
                    Write-Output "ipv6=$(get_local_ipv6)" >> $5_
                    host_ipv6_update $ls_ $iniFile[$1_].name $(get_local_ipv6) $3_ 
                }
            }
        }
        windows{
            Test-Connection -Count 2 $iniFile[$1_].ip
            if ($? -eq $false) {
                Write-Output "Windows offline"
            }else{
                
                if ($iniFile[$1_].use_ipv4 -eq "true") {
                    if ($($history_file.Keys -ccontains $1_) -ne $true){$3_ = ""}else{$3_ = $history_file[$1_].ipv4}
                    
                    $2_ = $(get_windows_ipv4 $iniFile[$1_].user $iniFile[$1_].ip $4_ $iniFile[$1_].key)
                    Write-Output "ipv4=$2_"
                    Write-Output "prev_ipv4=$3_"
                    host_ipv4_update $ls_ $iniFile[$1_].name $2_ $3_ 
                    
                }
                if ($iniFile[$1_].use_ipv6 -eq "true") {
                    if ($($history_file.Keys -ccontains $1_) -ne $true){$3_ = ""}else{$3_ = $history_file[$1_].ipv6}
                    $2_ = $(get_windows_ipv6 $iniFile[$1_].user $iniFile[$1_].ip $4_ $iniFile[$1_].key)
                    Write-Output "ipv6=$2_"
                    Write-Output "prev_ipv6=$3_"
                    host_ipv6_update $ls_ $iniFile[$1_].name $2_ $3_ 
                }
            }
        }
        linux{
            Test-Connection -Count 2 $iniFile[$1_].ip
            if ($? -eq $false) {
                Write-Output "Linux offline"
            }else{
                
                if ($iniFile[$1_].use_ipv4 -eq "true") {
                    if ($($history_file.Keys -ccontains $1_) -ne $true){$3_ = ""}else{$3_ = $history_file[$1_].ipv4}
                    $2_ = $(get_linux_ipv4 $iniFile[$1_].user $iniFile[$1_].ip $4_ $iniFile[$1_].key $iniFile[$1_].command_type)
                    Write-Output "ipv4=$2_"
                    Write-Output "prev_ipv4=$3_"
                    host_ipv4_update $ls_ $iniFile[$1_].name $2_ $3_ 

                }
                if ($iniFile[$1_].use_ipv6 -eq "true") {
                    if ($($history_file.Keys -ccontains $1_)-ne $true){$3_ = ""}else{$3_ = $history_file[$1_].ipv6}
                    $2_ = $(get_linux_ipv6 $iniFile[$1_].user $iniFile[$1_].ip $4_ $iniFile[$1_].key $iniFile[$1_].command_type)
                    Write-Output "ipv6=$2_"
                    Write-Output "prev_ipv6=$3_"
                    host_ipv6_update $ls_ $iniFile[$1_].name $2_ $3_ 
                }
            }
        }
        Default {Write-Output "unknow type"}
    }
}
皮一下