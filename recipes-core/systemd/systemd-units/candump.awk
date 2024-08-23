# Linux: https://elixir.bootlin.com/linux/master/source/include/uapi/linux/can.h#L56
#        https://elixir.bootlin.com/linux/master/source/include/uapi/linux/can/error.h
# PEAK CAN TRC File Format: https://www.peak-system.com/produktcd/Pdf/English/PEAK_CAN_TRC_File_Format.pdf
{
    if (1==NR)
    {
        ENVIRON["TZ"] = "UTC"
        getline uptimeOutput < "/proc/uptime"
        split(uptimeOutput, uptimeFields, " ")
        uptime = uptimeFields[1]
        startTimestampRelative = substr($1, 2, length($1) - 2)
        startTimestamp = systime() - uptime + startTimestampRelative
        printf(";$FILEVERSION=1.3\n")
        printf(";$STARTTIME=%u.%.0f\n", mktime(strftime("%Y %m %d 0 0 0", startTimestamp)) / 86400 + 25569, \
                10000000000.0 / 86400.0 * (mktime(strftime("%Y %m %d %H %M %S", startTimestamp)) - mktime(strftime("%Y %m %d 0 0 0", startTimestamp))))
        printf(";\n; Uptime:    %f\n", uptime)
        printf(";\n; Starttime: %f\n", startTimestampRelative)
        printf(";            %f\n", startTimestamp)
        printf(";            %s\n;\n", strftime("%Y-%m-%dT%H:%M:%S%z (%Z)", startTimestamp))
        currentTimeOffset = 0.0
    }
    else
    {
        currentTimestamp = substr($1, 2, length($1) - 2)
        currentTimeOffset = currentTimestamp - startTimestampRelative
    }
    if ("ERRORFRAME" == $NF)
    {
        printf ";"$0"\n;  "
        if ("20000001" == $3)
        {
            printf "TX timeout (by netdevice driver)\n"
            printf("%u) %.3f 1 Error 0008 - 4 00 00 00 00", NR, currentTimeOffset * 1000)
        }
        else if ("20000002" == $3)
        {
            printf "lost arbitration: "
            if ("00" != $5) printf("in bit number %u\n", $5)
            else            printf "unspecified\n"
            printf("%u) %.3f 1 Error 0008 - 4 00 00 00 00", NR, currentTimeOffset * 1000)
        }
        else if ("20000004" == $3)
        {
            printf "controller problems: "
            direction = 0
            errors = "0"
            if      ("00" == $6) { printf "unspecified\n" }
            else if ("01" == $6) { printf "RX buffer overflow\n"; errors = "40"; direction = 1 }
            else if ("02" == $6) { printf "TX buffer overflow\n"; errors = "40" }
            else if ("04" == $6) { printf "reached warning level for RX errors\n"; errors = "60"; direction = 1 }
            else if ("08" == $6) { printf "reached warning level for TX errors\n"; errors = "60" }
            else if ("10" == $6) { printf "reached error passive status RX\n"; errors = "80"; direction = 1 }
            else if ("20" == $6) { printf "reached error passive status TX\n"; errors = "80" }
            else if ("40" == $6) { printf "recovered to error active state\n" }
            if (1 == direction) printf("%u) %.3f 1 Error 0000 - 4 01 00 %s 00", NR, currentTimeOffset * 1000, errors)
            else                printf("%u) %.3f 1 Error 0000 - 4 00 00 00 %s", NR, currentTimeOffset * 1000, errors)
        }
        else if ("20000008" == $3)
        {
            printf "protocol violations: "
            type = "0008"
            position = $8
            if      ("00" == $7) { printf "unspecified" }
            else if ("01" == $7) { printf "single bit error"; type = "0001" }
            else if ("02" == $7) { printf "frame format error"; type = "0002" }
            else if ("04" == $7) { printf "bit stuffing error"; type = "0004" }
            else if ("08" == $7) { printf "unable to send dominant bit" }
            else if ("10" == $7) { printf "unable to send recessive bit " }
            else if ("20" == $7) { printf "bus overload" }
            else if ("40" == $7) { printf "active error announcement" }
            else if ("80" == $7) { printf "error occurred on transmission" }
            printf " @ "
            if      ("00" == $8) printf "unspecified\n"
            else if ("03" == $8) printf "start of frame\n"
            else if ("02" == $8) printf "ID bits 28 - 21 (SFF: 10 - 3)\n"
            else if ("06" == $8) printf "D bits 20 - 18 (SFF: 2 - 0)\n"
            else if ("04" == $8) printf "substitute RTR (SFF: RTR)\n"
            else if ("05" == $8) printf "identifier extension\n"
            else if ("07" == $8) printf "ID bits 17-13\n"
            else if ("0F" == $8) printf "ID bits 12-5\n"
            else if ("0E" == $8) printf "ID bits 4-0\n"
            else if ("0C" == $8) printf "RTR\n"
            else if ("0D" == $8) printf "reserved bit 1\n"
            else if ("09" == $8) printf "reserved bit 0\n"
            else if ("0B" == $8) printf "data length code\n"
            else if ("0A" == $8) printf "data section\n"
            else if ("08" == $8) printf "CRC sequence\n"
            else if ("18" == $8) printf "CRC delimiter\n"
            else if ("19" == $8) printf "ACK slot\n"
            else if ("1B" == $8) printf "ACK delimiter\n"
            else if ("1A" == $8) printf "end of frame\n"
            else if ("12" == $8) printf "intermission\n"
            printf("%u) %.3f 1 Error %s - 4 00 %s 00 00", NR, currentTimeOffset * 1000, type, position)
        }
        else if ("20000010" == $3)
        {
            printf "transceiver status: "
            if      ("00" == $9) printf "UNSPEC\n"
            else if ("04" == $9) printf "CANH_NO_WIRE\n"
            else if ("05" == $9) printf "CANH_SHORT_TO_BAT\n"
            else if ("06" == $9) printf "CANH_SHORT_TO_VCC\n"
            else if ("07" == $9) printf "CANH_SHORT_TO_GND\n"
            else if ("40" == $9) printf "CANL_NO_WIRE\n"
            else if ("50" == $9) printf "CANL_SHORT_TO_BAT\n"
            else if ("60" == $9) printf "CANL_SHORT_TO_VCC\n"
            else if ("70" == $9) printf "CANL_SHORT_TO_GND\n"
            else if ("80" == $9) printf "CANL_SHORT_TO_CANH\n"
            printf("%u) %.3f 1 Error 0008 - 4 00 1C 00 00", NR, currentTimeOffset * 1000)
        }
        else if ("20000020" == $3)
        {
            printf "received no ACK on transmission\n"
            printf("%u) %.3f 1 Error 0008 - 4 00 00 00 00", NR, currentTimeOffset * 1000)
        }
        else if ("20000040" == $3)
        {
            printf "bus off\n"
            printf("%u) %.3f 1 Error 0000 - 4 00 00 FF FF", NR, currentTimeOffset * 1000)
        }
        else if ("20000080" == $3)
        {
            printf "bus error\n"
            printf("%u) %.3f 1 Error 0008 - 4 00 00 00 00", NR, currentTimeOffset * 1000)
        }
        else if ("20000100" == $3)
        {
            printf "controller restarted\n"
            printf("%u) %.3f 1 Error 0000 - 4 00 00 00 00", NR, currentTimeOffset * 1000)
        }
    }
    else
    {
        if (3>=NF)
        {
            invalidLineFound = 1
        }
        if (1==invalidLineFound)
        {
            printf ";"
        }
        printf("%u) %.3f 1 Rx %s - %s", NR, currentTimeOffset * 1000, $3, substr($4, 2, length($4) - 2))
        if (5<=NF)
        {
            for (i=5;i<=NF;i++)
            {
                printf " "$i
            }
        }
    }
    printf "\n"
}
