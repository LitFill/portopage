module lib/contact

pub struct contact
    provider : string
    displayname : string
    link : string

pub inline fun contact/show(c)
    c.provider ++ " as " ++ c.displayname ++ "["++c.link++"]"

pub val contacts = [
    Contact("GitHub", "LitFill", "https://github.com/LitFill"),
    Contact("X", "LitFill", "https://x.com/razzy_ar"),
    Contact("Discord", "LitFill", "https://discord.gg/3ME4r6DB"),
]
