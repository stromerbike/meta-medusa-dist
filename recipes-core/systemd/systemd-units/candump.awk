{
    if (1==NR)
    {
        printf(";$FILEVERSION=1.3\n")
        printf(";$STARTTIME=%u.%u\n", mktime(strftime("%Y %m %d 0 0 0", systime())) / 86400 + 25569, \
                10000000000 / 86400 * (mktime(strftime("%Y %m %d %H %M %S", systime())) - mktime(strftime("%Y %m %d 0 0 0", systime()))))
        currentTimestamp = 0.0
    }
    else
    {
        previousTimestamp = currentTimestamp
        currentTimestamp = previousTimestamp + substr($1, 2, length($1) - 2)
    }
    printf("%u) %.3f 1 Rx %s - %s", NR, currentTimestamp * 1000, $3, substr($4, 2, length($4) - 2))
    if (5<=NF)
    {
        for(i=5;i<=NF;i++)
        {
            printf " "$i
        }
    }
    printf "\n"
}
