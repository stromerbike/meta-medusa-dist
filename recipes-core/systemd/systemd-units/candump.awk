{
    if (1==NR)
    {
        startTimestamp = substr($1, 2, length($1) - 2)
        printf(";$FILEVERSION=1.3\n")
        printf(";$STARTTIME=%u.%u\n", mktime(strftime("%Y %m %d 0 0 0", startTimestamp)) / 86400 + 25569, \
                10000000000 / 86400 * (mktime(strftime("%Y %m %d %H %M %S", startTimestamp)) - mktime(strftime("%Y %m %d 0 0 0", startTimestamp))))
    }
    printf("%u) %.3f 1 Rx %s - %s", NR, (substr($1, 2, length($1) - 2) - startTimestamp) * 1000, $3, substr($4, 2, length($4) - 2))
    if (5<=NF)
    {
        for(i=5;i<=NF;i++)
        {
            printf " "$i
        }
    }
    printf "\n"
}
