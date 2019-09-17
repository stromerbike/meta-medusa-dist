{
    if (1==NR)
    {
        startTimestamp = substr($1, 2, length($1) - 2)
        printf(";$FILEVERSION=1.3\n")
        printf(";$STARTTIME=%u.%.0f\n", mktime(strftime("%Y %m %d 0 0 0", startTimestamp)) / 86400 + 25569, \
                10000000000.0 / 86400.0 * (mktime(strftime("%Y %m %d %H %M %S", startTimestamp)) - mktime(strftime("%Y %m %d 0 0 0", startTimestamp))))
        printf(";\n; Start time: %s\n", startTimestamp)
        printf(";             %u\n", mktime(strftime("%Y %m %d %H %M %S", startTimestamp)))
        printf(";             %s\n;\n", strftime("%Y-%m-%dT%H:%M:%S%z (%Z)", startTimestamp))
        currentTimeOffset = 0.0
    }
    else
    {
        previousTimeOffset = currentTimeOffset
        currentTimestamp = substr($1, 2, length($1) - 2)
        currentTimeOffset = currentTimestamp - startTimestamp
        if (currentTimeOffset < 0)
        {
            startTimestamp = currentTimestamp + currentTimeOffset
            currentTimeOffset = previousTimeOffset
        }
    }
    printf("%u) %.3f 1 Rx %s - %s", NR, currentTimeOffset * 1000, $3, substr($4, 2, length($4) - 2))
    if (5<=NF)
    {
        for(i=5;i<=NF;i++)
        {
            printf " "$i
        }
    }
    printf "\n"
}
