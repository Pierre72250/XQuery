(::| XQuery Pierre Fouillet & Pierre Gaudicheau |::)

(::| Déclaration des espaces de nom |::)
xquery version "3.0";
declare namespace ass = "http://schemas.assemblee-nationale.fr/referentiel";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

(::| Ligne XQuery pour l'indentation |::)
declare option output:method "xml";
declare option output:media-type "text/xml";
declare option output:omit-xml-declaration "no";
declare option output:indent "yes";
declare option output:doctype-system "assemblee1920.dtd";


(::| XQuery |::)
<information>
    {
        for $i in /assemblée/liste-acteurs/ass:acteur
            let $uid := $i/ass:uid
            order by $i/ass:etatCivil/ass:ident/ass:nom/text(), $i/ass:etatCivil/ass:ident/ass:prenom/text()
        return
        if ($uid = /assemblée/liste-scrutins/ass:scrutin[contains(ass:titre, 'l''information')]/ass:ventilationVotes/ass:organe/ass:groupes/ass:groupe/ass:vote/ass:decompteNominatif/ass:pours/ass:votant/ass:acteurRef) then
            let $nomActeur := (concat($i/ass:etatCivil/ass:ident/ass:prenom/text(), ' ', $i/ass:etatCivil/ass:ident/ass:nom/text()))
            <act nom="{$nomActeur}"> {
            for $j in /assemblée/liste-scrutins/ass:scrutin[contains(ass:titre, 'l''information')]/ass:ventilationVotes/ass:organe/ass:groupes/ass:groupe/ass:vote/ass:decompteNominatif/ass:pours/ass:votant/ass:acteurRef[./text() = $uid]
                let scrutin := $j/../../../../../../../../..
                let titre := $scrutin/ass:titre
                let sort := $scrutin/ass:sort/ass:code
                let date := $scrutin/ass:dateScrutin
                let $estPresent := if ($j/../ass:parDelegation/text() eq 'true') then ("non") else ("oui")
            return
                <scrutin titre="{$titre}"
                    sort="{$sort}" 
                    date="{$date}"
                    mandat="{/assemblée/liste-organes/ass:organe[./ass:uid eq /assemblée/liste-acteurs/ass:acteur/ass:mandats/ass:mandat[./ass:uid eq $j/../ass:mandatRef/text()]/ass:organes/ass:organeRef]/ass:libelle}"
                    grp="{/assemblée/liste-organes/ass:organe[./ass:uid eq $j/../../../../../ass:organeRef]/ass:libelle}"
                    présent ="{$estPresent}"/>
            }
            </act>
        else ()
    }
</information>
