# --------------------------------------
# STUDENTS
# --------------------------------------

param(
    [int]$GroupSize = 8   # default if not provided
)

$STUDENTS = @(
"300139389|octocat|583231"
"300142542|anouarairn|157492270"
"300142636|octocat|583231"
"300145955|arianemaeva03-star|231501283"
"300150410|lahlou06|231570554"
"300150468|sahebmohandsaid97-oss|232939143"
"300150470|hacene-ifticene|277295412"
"300150496|mohamedaymenmedjras-dev|231500876"
"300151483|arnauld-ttad|231570852"
"300151504|Nassimidir|232939073"
"300151548|octocat|583231"
"300151588|belhAmine|58528251"
"300151589|walidwolf31|231501417"
"300151753|kheloufinourdine48-rgb|266413355"
"300151834|amirlounaci-bit|266591188"
"300152247|octocat|583231"
"300153401|youneschaghica-hub|266600832"
"300153602|meryemabdedou83-ux|266413722"
"300153605|siham-sys|266167340"
"300153932|yakss132-sys|231499661"
"300153972|rimfive|173731510"
"300154479|dylanengabou-beep|260781405"
"300155045|chouaibait|232956639"
"300155881|fairouz97|231500665"
"300155884|patricia-nguemedzi|266604081"
"300156533|raoufrm-4|231499534"
"300156627|rougaiyatoudiallo|118176543"
"300157287|Cheikau|231501940"
"300157334|laalahamdaoui16-alt|231569676"
"300157440|Houssam-eddinerachdi|231572368"
"300157736|souhilaazzouz036-tech|231500022"
"300158052|octocat|583231"
"300158185|Mohammed-mati|232939280"
"300158383|salmabaali|231501135"
)

# --------------------------------------
# CONFIG
# --------------------------------------

$GROUP_SIZE = $GroupSize

# --------------------------------------
# FUNCTION - Dynamic grouping
# --------------------------------------

function New-Groups {
    param (
        [array]$Items,
        [int]$Size
    )

    $groups = @()

    for ($i = 0; $i -lt $Items.Count; $i += $Size) {
        $end = [Math]::Min($i + $Size - 1, $Items.Count - 1)
        $groups += ,@($Items[$i..$end])
    }

    return $groups
}

# --------------------------------------
# BUILD STUDENT GROUPS
# --------------------------------------

$GROUPS = New-Groups -Items $STUDENTS -Size $GROUP_SIZE

# --------------------------------------
# SERVERS
# --------------------------------------

$SERVERS = @(
"10.7.236.201"
"10.7.236.202"
"10.7.236.203"
"10.7.236.204"
"10.7.236.205"
"10.7.236.206"
"10.7.236.207"
"10.7.236.208"
"10.7.236.209"
"10.7.236.210"
"10.7.236.211"
"10.7.236.212"
"10.7.236.213"
"10.7.236.214"
"10.7.236.215"
"10.7.236.216"
"10.7.236.217"
"10.7.236.218"
"10.7.236.219"
"10.7.236.220"
"10.7.236.221"
"10.7.236.222"
"10.7.236.223"
"10.7.236.224"
"10.7.236.225"
"10.7.236.226"
"10.7.236.227"
"10.7.236.228"
"10.7.236.229"
"10.7.236.230"
"10.7.236.231"
"10.7.236.232"
"10.7.236.233"
"10.7.236.234"
)

$SERVER_GROUPS = New-Groups -Items $SERVERS -Size $GROUP_SIZE

# --------------------------------------
# WINDOWS SERVERS (1 per group)
# --------------------------------------

$WINDOWS_SERVERS = @(
"10.7.236.237"
"10.7.236.238"
"10.7.236.239"
"10.7.236.240"
)

# --------------------------------------
# OPTIONAL: MERGED LAB OBJECT (🔥 recommandé)
# --------------------------------------

$LAB_GROUPS = for ($i = 0; $i -lt $GROUPS.Count; $i++) {
    [PSCustomObject]@{
        Id        = $i + 1
        Students  = $GROUPS[$i]
        Servers   = $SERVER_GROUPS[$i]
        Proxmox   = $WINDOWS_SERVERS[$i]
    }
}

# --------------------------------------
# PROF / LMS
# --------------------------------------

$PK_PROF="b300098957@ramena"
$LMS_COURSE=10
