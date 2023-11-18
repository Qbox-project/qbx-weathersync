local Translations = {
    weather = {
        now_frozen = 'Počasí je nyní zamrzlé.',
        now_unfrozen = 'Počasí již není zamrzlé.',
        invalid_syntax = 'Neplatná syntaxe, správná syntaxe je: /weather <typPočasí> ',
        invalid_syntaxc = 'Neplatná syntaxe, použijte /weather <typPočasí>!',
        updated = 'Počasí bylo aktualizováno.',
        invalid = 'Neplatný typ počasí, platné typy počasí jsou: \nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ',
        invalidc = 'Neplatný typ počasí, platné typy počasí jsou: \nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ',
        willchangeto = 'Počasí se změní na: %{value}.',
        accessdenied = 'Přístup k příkazu /weather byl odepřen.',
    },
    dynamic_weather = {
        disabled = 'Dynamické změny počasí jsou nyní vypnuty.',
        enabled = 'Dynamické změny počasí jsou nyní zapnuty.',
    },
    time = {
        frozenc = 'Čas je nyní zamrzlý.',
        unfrozenc = 'Čas již není zamrzlý.',
        now_frozen = 'Čas je nyní zamrzlý.',
        now_unfrozen = 'Čas již není zamrzlý.',
        morning = 'Čas nastaven na ráno.',
        noon = 'Čas nastaven na poledne.',
        evening = 'Čas nastaven na večer.',
        night = 'Čas nastaven na noc.',
        change = 'Čas byl změněn na %{value}:%{value2}.',
        changec = 'Čas byl změněn na: %{value}!',
        invalid = 'Neplatná syntaxe, správná syntaxe je: time <hodina> <minuta> !',
        invalidc = 'Neplatná syntaxe. Použijte /time <hodina> <minuta> místo toho!',
        access = 'Přístup k příkazu /time byl odepřen.',
    },
    blackout = {
        enabled = 'Blackout je nyní zapnut.',
        enabledc = 'Blackout je nyní zapnut.',
        disabled = 'Blackout je nyní vypnut.',
        disabledc = 'Blackout je nyní vypnut.',
    },
    help = {
        weathercommand = 'Změna počasí.',
        weathertype = 'typPočasí',
        availableweather = 'Dostupné typy: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas a halloween',
        timecommand = 'Změna času.',
        timehname = 'hodiny',
        timemname = 'minuty',
        timeh = 'Číslo mezi 0 - 23',
        timem = 'Číslo mezi 0 - 59',
        freezecommand = 'Zmrazit / rozmrazit čas.',
        freezeweathercommand = 'Povolit / zakázat dynamické změny počasí.',
        morningcommand = 'Nastavit čas na 09:00',
        nooncommand = 'Nastavit čas na 12:00',
        eveningcommand = 'Nastavit čas na 18:00',
        nightcommand = 'Nastavit čas na 23:00',
        blackoutcommand = 'Přepnout režim blackout.',
    },
}


if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
--translate by stepan_valic