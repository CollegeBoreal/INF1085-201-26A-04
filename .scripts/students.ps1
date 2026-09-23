# --------------------------------------
# STUDENTS
# --------------------------------------

param(
    [int]$GroupSize = 8   # default if not provided
)

$STUDENTS = @(
"300142542|anouarairn|157492270"
"300145955|arianemaeva03-star|231501283"
"300150410|octocat|583231"
"300150468|octocat|583231"
"300150470|hacene-ifticene|277295412"
"300150496|mohamedaymenmedjras-dev|231500876"
"300151483|arnauld-ttad|231570852"
"300151504|Nassimidir|232939073"
"300151588|belhAmine|58528251"
"300151589|walidwolf31|231501417"
"300151753|kheloufinourdine48-rgb|266413355"
"300151834|amirlounaci-bit|266591188"
"300153401|youneschaghica-hub|266600832"
"300153602|meryemabdedou83-ux|266413722"
"300153605|siham-sys|266167340"
"300153932|yakss132-sys|231499661"
"300153972|octocat|583231"
"300154479|dylanengabou-beep|260781405"
"300155045|octocat|583231"
"300155881|fairouz97|231500665"
"300155884|patricia-nguemedzi|266604081"
"300156533|raoufrm-4|231499534"
"300156627|rougaiyatoudiallo|118176543"
"300157287|Cheikau|231501940"
"300157334|laalahamdaoui16-alt|231569676"
"300157440|octocat|583231"
"300157736|octocat|583231"
"300158052|octocat|583231"
"300158185|octocat|583231"
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
"10.7.237.201"
"10.7.237.202"
"10.7.237.203"
"10.7.237.204"
"10.7.237.205"
"10.7.237.206"
"10.7.237.207"
"10.7.237.208"
"10.7.237.209"
"10.7.237.210"
"10.7.237.211"
"10.7.237.212"
"10.7.237.213"
"10.7.237.214"
"10.7.237.215"
"10.7.237.216"
"10.7.237.217"
"10.7.237.218"
"10.7.237.219"
"10.7.237.220"
"10.7.237.221"
"10.7.237.222"
"10.7.237.223"
"10.7.237.224"
"10.7.237.225"
"10.7.237.226"
"10.7.237.227"
"10.7.237.228"
"10.7.237.229"
"10.7.237.230"
"10.7.237.231"
"10.7.237.232"
"10.7.237.233"
)

$SERVER_GROUPS = New-Groups -Items $SERVERS -Size $GROUP_SIZE

# --------------------------------------
# WINDOWS SERVERS (1 per group)
# --------------------------------------

$WINDOWS_SERVERS = @(
"10.7.237.7"
"10.7.237.35"
"10.7.237.24"
"10.7.237.28"
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
$LMS_COURSE=6
