defmodule FebrdBot.Filter do

  @badwords [
    # General Negative Terms
    "damn", "awful", "terrible", "horrible", "dreadful", "poor", "miserable", "unpleasant",
    "disappointing", "sad", "depressing", "distressing", "negative", "unfortunate", "unhappy",
    "dismal", "painful", "distasteful", "regretful", "frustrating", "angry", "upset",
    "annoying", "irritating", "disturbing", "revolting", "repulsive", "sickening", "disgusting",
    "shocking", "appalling", "grotesque", "repugnant", "vile", "loathsome", "wretched",
    "abominable", "detestable", "repellent", "unbearable", "intolerable", "unacceptable",
    "unseemly", "disgraceful", "dismal", "bleak", "regrettable", "heartbreaking",
    "disheartening", "deplorable", "shameful", "atrocious", "heinous", "abominable",

    # Racial and Ethnic Slurs
    "nigger", "chink", "spic", "gook", "raghead", "wetback", "sandnigger", "coon",
    "dago", "guinea", "haji", "honky", "jap", "kraut", "mick", "paki", "pollock",
    "slope", "wop", "yid", "zipperhead", "boong", "gook", "hymie", "kike", "nazi",
    "redskin", "skid", "spade", "towelhead", "tribal", "wetback", "brownie", "spade",

    # Gender and Sexuality Slurs
    "tranny", "trannie", "sexchange", "faggotry", "lesbo", "dyke", "queer", "homosexual",
    "transvestite", "transsexual", "twink", "shemale", "butch", "pansy", "chick", "bender",
    "straight", "gay", "bi", "homo", "sexist", "misogynistic", "misandrist", "chauvinist",
    "rape", "molestation", "abuse", "pervert", "deviant", "slut", "whore", "hooker",
    "escort", "callgirl", "prostitute", "stripper", "stipper", "naked", "bareback",
    "peep", "streaking", "swinger", "incest", "fistfuck", "sadism", "masochism",
    "anal", "pussy", "cum", "jizz", "bukkake", "orgasm", "porn", "sodomy",

    # Discriminatory and Insulting Terms
    "racism", "bigot", "xenophobic", "hate", "bigotry", "discrimination", "abusive",
    "harassment", "bullying", "slur", "discriminatory", "offensive", "insulting",
    "derogatory", "unethical", "profane", "vulgar", "obscene", "indecent", "disgraceful",
    "unseemly", "unfit", "distasteful", "unacceptable", "intolerable", "dismal",
    "grating", "annoying", "irritating", "disturbing", "off-putting", "revolting",
    "repulsive", "despicable", "heinous", "atrocious", "abominable", "wretched",
    "repugnant", "loathsome", "deplorable", "sickening", "shameful", "disgusting",
    "unpleasant", "heartbreaking", "shocking", "appalling", "grotesque", "repellent",
    "revulsive", "reprehensible", "degrading", "demeaning", "oppressive", "threatening",
    "menacing", "harsh", "cruel", "inhuman",

    "😠", "😡", "🤬", "😢", "😭", "😞", "😔", "😟", "😰", "😥", "😫", "😩", "😿", "😣",
    "💔", "🤯", "😧", "🙁", "😒", "🤢", "🤮", "😵", "🤕", "😖", "😤", "🤬", "😨", "😫",
    ":(", ":-(", ":/", ":|", ":(", ">:("
  ]


  @inappropriate [
    # General Offensive Terms
    "abuse", "asshole", "bastard", "bitch", "cunt", "dick", "fag", "faggot",
    "fuck", "motherfucker", "piss", "shit", "slut", "twat", "whore", "wanker",
    "douchebag", "cocksucker", "prick", "cocks", "vagina", "penis", "fist", "rape",
    "molest", "pedophile", "retard", "idiot", "moron", "simpleton", "dumbass",
    "dumbfuck", "shithead", "fuckface", "fucktard", "prickface", "shitfuck",
    "slutbag", "whorebag", "cumslut", "pussylips", "ballbag", "cockbag", "cuntface",
    "dickhead", "dickwad", "cocksucking", "asslicking", "pussy", "butt", "asshole",
    "cunt", "cocksucker", "motherfucking", "bastard", "douche", "blowjob", "handjob",
    "cumshot", "deepthroat", "gangbang", "fisting", "sodomize", "sex", "porn", "fetish",
    "anal", "vulgar", "obscene", "indecent", "blasphemy", "sacrilegious", "inappropriate",

    # Racial and Ethnic Slurs
    "nigger", "chink", "spic", "gook", "raghead", "wetback", "cameltoe",
    "sandnigger", "coon", "dago", "guinea", "haji", "honky", "jap", "kraut",
    "mick", "paki", "pollock", "slope", "wop", "yid", "zipperhead", "boong",
    "gook", "hymie", "kike", "nazi", "redskin", "skid", "spade", "towelhead",
    "tribal", "wetback", "brownie", "spade", "racial", "ethnic", "savage",


    "tranny", "trannie", "sexchange", "faggotry", "lesbo", "dyke", "queer", "homosexual",
    "transvestite", "transsexual", "twink", "shemale", "butch", "pansy", "chick",
    "bender", "straight", "gay", "bi", "homo", "sexist", "misogynistic", "misandrist",
    "chauvinist", "rape", "molestation", "abuse", "pervert", "deviant", "slut", "whore",
    "hooker", "escort", "callgirl", "prostitute", "stripper", "stipper", "naked",
    "bareback", "peep", "streaking", "swinger", "incest", "fistfuck", "sadism",
    "masochism", "anal", "pussy", "cum", "jizz", "bukkake", "orgasm", "porn", "sodomy",


    "racism", "bigot", "xenophobic", "hate", "bigotry", "discrimination", "abusive",
    "harassment", "bullying", "slur", "discriminatory", "offensive", "insulting",
    "derogatory", "unethical", "profane", "vulgar", "obscene", "indecent", "disgraceful",
    "unseemly", "unfit", "distasteful", "unacceptable", "intolerable", "dismal", "grating",
    "annoying", "irritating", "disturbing", "off-putting", "revolting", "repulsive",
    "despicable", "heinous", "atrocious", "abominable", "wretched", "repugnant",
    "loathsome", "deplorable", "shameful", "sickening", "disgusting", "unpleasant",
    "heartbreaking", "shocking", "appalling", "grotesque", "repellent", "repugnant",
    "vile", "loathsome", "wretched", "abominable", "distasteful", "insufferable",
    "intolerable", "unbearable", "detestable", "revulsive", "reprehensible",
    "degrading", "degrading", "disrespectful", "insulting", "dehumanizing",
    "demeaning", "oppressive", "threatening", "menacing", "harsh", "cruel", "inhuman"
  ]

  def check_message(message) do
    message
    |> String.downcase()
    |> String.split(~r/\s+/, trim: true)
    |> Enum.any?(fn word -> word in @badwords or word in @inappropriate end)
  end

end
