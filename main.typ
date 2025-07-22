#set text(font:"New Computer Modern", lang:"cs", size:10.5pt)

#let footer_texts = (
  [*Odpovědi: 1c, 2b, 3b, 4a, 5aef*\
  Amdahlův zákon: $S = 1/((1-p)+p/s)$ Zlepšení (%) $= 100(1-1/S) = 100(p-p/s)$. Pro cvičení 4 je $p=0.2$ a $s=10$.],
  [*Odpovědi: 6dgk*],
  [*Odpovědi: 7abceg, 8ade, 9acdf*\
  Poznámka pro 9:
  https://www.openmp.org/spec-html/5.0/openmpsu32.html#x51-710002.5.3],
  [*Odpovědi: 10b* (díky direktivě nowait)*, 11e, 12be*],
  [*Odpovědi: 13(b)e *(funkce mutex vyžaduje min 2 argumenty)*, 14b, 15c, 16b*],
  [*Odpovědi: 17ae* (Jeden task ho může zamknout vícekrát bez deadlocku. Ostatní tasky se k locku dostanou až ve chvíli, kdy ho owning task odemkne tolikrát, kolikrát ho dříve zamknul. Odpovědi jsou za předpokladu, že A ani B nepracuje s mutexy.) (e je možná špatně, protože pokud první vlákno uzamkne mutex a selže v B, tak zůstane uzamčen)*, 18cdeik*],
  [*Odpovědi: 19b*(6x ELECTION, 3x OK, 2x COORDINATOR)*, c*(P1 pošle ELECTION, přijme to P5, začne timout a pošle všem ostatním ELECTION, po timeoutu pošle COORDINATION)* f, 20ehi*],
  [*Odpovědi: 21bcd, 22ace*],
  [*Odpovědi: 23abc, 24efhj*],
  [*Odpovědi: 25dhi *(RAFT nemůže přestat být úplný, vždy detekuje, ale možná chybně)*, 26a*],
  [*Odpovědi: 27fhij , 28f*],
  [*Odpovědi: 29b, 30abd, 31a*],
  [*Odpovědi: 32d, 33a*],
  [*Odpovědi: 34aefjk *(barrier je jen na konci sections, ne na začátku)* , 35e*],
  [*Odpovědi: 36bcdf*(většinou se ale vypíše s 0 na začátku, ale v možnostech chybí)*, 37b, 38c*],
  [*Odpovědi: 39bdg, 40dgh, 41c*],
  [*Odpovědi: 42acdef - e je možný že ne, běžný forloop bude fungovat bez toho, 43bc, 44abc, 45c*(a- latence může změnit pořadí, b- pořadí je dané kruhem)*, 46a* (a- 3, b- od 0 do n, c- 2(n-1) )],
  [*Odpovědi: 47be, 48cef, 49cde*],
  [*Odpovědi: 50- hodnota 0, 1, 2 nebo 3, 51a*],
  [*Odpovědi: 52bc*(při nastaveném jen jednom vláknu)*de, 53c*],
  [*Odpovědi: 54a, 55c* (`cancellation point` je špatně umístěn, neukončil by se vnější cyklus)],
  [*Odpovědi: 56a, 57abd, 58a--0 b--1 c--7 d--4*],
  [*Odpovědi: 59 a--8, b--5, c--5,3,3, d--2,2,1*],
  [*Odpovědi: 60bd*(*c* pokud chtějí slyšet jen vzoreček, *d* pokud chtějí konkrétní číslo)*ef*],
  [*Odpovědi: 61bcg, 62acd*],
  [*Odpovědi: 63bcehikl, 64: 9 90 10, 65: 2 2 2, 66bde*],
  [*Odpovědi: 67beij, 68a) 250; b) 40* ($260-100=160$, $160-80=80$ (časové rozmezí ve kterém nevíme kdy přesně byl čas naměřen), tedy zvolíme půlku tohoto intervalu jako odchylku a naměřený čas umístíme doprostřed  odchylka $80/2=40$, čas $150+40+60=250$)],
  [*Odpovědi: 69 a) uzavře P3 $->$ P1, b) záznam lok stavu, pošle P1, P3, začne odposlouchávání P1 $->$ P2 c) žádná operace*],
  [*Odpovědi: 70cde*],
  [*Odpovědi: 71cehj*],
  [*Odpovědi: 72ah*],
  [*Odpovědi: 73aceh*],
)

#set page(
  margin: (
    top: 2cm,
    bottom: 3.5cm,
    x: 2.5cm,
  ),
  footer: context {
    let page_num = counter(page).get().at(0)

    // Typst numbers pages from 1, arrays from 0.
    if page_num <= footer_texts.len() {
      let current_text = footer_texts.at(page_num - 1)
      align(left, current_text)
    } else {
      align(center, " ")
    }
    align(center, [str. #counter(page).display()])
  }
)

#set align(center)
= Řešené teoretické otázky pro B4B36PDV
\
\
#set align(left)
#set enum(numbering: "a)")
*1. Proč je falešné sdílení (false sharing) problémem:* \

+ Překladač: Překladač není schopen pro paralelizaci vygenerovat optimální strojový kód
+ Správnost: Paralelizace povede k nedeterministickým výsledkům
+ Výkon: Zrychlení dané paralelizací bude nižší, než by bylo možné jinak očekávat. Škálovatelnost paralelizace tak bude omezená

*2. Uvažujme třídu std::atomic:* \

+ Má copy constructor: class_name (const class_name &)
+ Nemá ani copy constructor, ani move constructor
+ Má move constructor: class_name (class_name &&)

*3. Falešné sdílení (false sharing) můžeme odstranit:* \

+ Pomocí podmíněné proměnné
+ Vytvořením lokální kopie sdílené proměnné
+ Pomocí globálního zámku nad sdílenou proměnnou

*4. Mějme sekvenční program. Předpokládejme, že výpočet trvá 20 % času, zbytek času je nevyužit či se čeká na I/O. Dále předpokládejme, že výpočet můžeme 10x zrychlit. Jak dlouho poběží paralelizace programu podle Amdahlova zákona?*

+ O 21.95 % rychleji
+ O 18 % rychleji
+ O 19.05 % rychleji
+ O 20 % rychleji
+ O 2 % rychleji

*5. Uvažujme distribuovaný výpočet v asynchronním distribuovaném systému. Uvažujme následující tři vlastnosti distribuovaných výpočtů - živost, bezpečnost a odolnost vůči selhání – a uvažujme jakých garancí na tyto vlastnosti jsme schopni dosáhnout, pokud příslušný distribuovaný algoritmus vhodně navrhneme:* \

+ Lze současně garantovat bezpečnost a živost
+ Lze současně garantovat bezpečnost, živost a odolnost vůči selháním
+ Lze garantovat buď bezpečnost nebo živost, ale ne obě vlastnosti dohromady
+ Lze garantovat buď bezpečnost nebo odolnost vůči selháním, ale ne obě vlastnosti dohromady
+ Lze současně garantovat bezpečnost a odolnost vůči selháním
+ Lze současně garantovat živost a odolnost vůči selháním
+ Lze garantovat buď živost nebo odolnost vůči selháním, ale ne obě vlastnosti dohromady

#pagebreak()

*6. V distribuovaném systému vykonávajícím výpočet zachycený na obrázku běží skalární i vektorové logické hodiny. Na začátku výpočtu jsou všechny hodiny inicializovány na nulové hodnoty.* \
#figure(
  image("resources/obr01.png", width: 100%, fit: "stretch"),
)
Označte všechna pravdivá tvrzení týkající se hodnot logického času v průběhu výpočtu

Pozn.: Jak pro skalární, tak pro vektorové hodnoty se dotazujeme na jejich hodnoty ve dvou různých okamžicích výpočtu. Pro každý z těchto okamžiků jsou v seznamu tři možné hodnoty, z nichž právě jedna je správná:
+ Hodnota vektorových hodin procesu P2 bezprostředně po události G bude (0,2,0)
+ Hodnota skalárních hodin procesu P3 bezprostředně po události L bude 9
+ Hodnota skalárních hodin procesu P3 bezprostředně po události L bude 6
+ Hodnota vektorových hodin procesu P2 bezprostředně po události G bude (2,2,0)
+ Hodnota vektorových hodin procesu P3 bezprostředně po události L bude (0,0,4)
+ Hodnota vektorových hodin procesu P3 bezprostředně po události L bude (5,3,4)
+ Hodnota vektorových hodin procesu P3 bezprostředně po události L bude (5,2,4)
+ Hodnota vektorových hodin procesu P2 bezprostředně po události G bude (2,2,1)
+ Hodnota skalárních hodin procesu P2 bezprostředně po události H bude 4
+ Hodnota skalárních hodin procesu P3 bezprostředně po události L bude 8
+ Hodnota skalárních hodin procesu P2 bezprostředně po události H bude 5
+ Hodnota skalárních hodin procesu P2 bezprostředně po události H bude 3

#pagebreak()

*7. V distribuovaném výpočtu zachyceném úplně na obrázku uvažujme uspořádání událostí. Označte všechny výroky, které jsou pravdivé vzhledem k uspořádání dle relace #underline[stalo se před]:* \
#figure(
  image("resources/obr01.png", width: 100%, fit: "stretch"),
)
+ Událost *I* se stala před událostí *E*
+ O kauzálním vztahu událostí *I* a *H* nelze rozhodnout
+ *I* a *H* jsou souběžné události
+ Událost *C* se stala před událostí *K*
+ *C* a *G* jsou souběžné události
+ *D* a *L* jsou souběžné události
+ Událost *F* se stala před událostí *L*
+ O kauzálním vztahu událostí *B* a *G* nelze rozhodnout

*8. Které z následující vlastností distribuovaného výpočtu jsou nutné k tomu, aby algoritmus Ricart-Agrawala garantoval bezpečnost a živost:*\

+ Ve výpočtu nedochází ke ztrátám zpráv.
+ Ve výpočtu nedochází ke zpoždění zpráv.
+ Doba odezvy procesů je kratší než doba strávená procesy v kritické sekci.
+ Ve výpočtu nedochází k haváriím procesů
+ Doba přenosu zpráv je kratší než time-out pro vstup do kritické sekce.

*9. Jak v OpenMP nastavím počet běžících vláken pro jeden cyklus na nejvyšší úrovni na X. Vyberte všechny správné odpovědi:* \

+ Nastavením tzv. “internal control variable” nthreads-var na X,1,1
+ Spuštěním programu s parametrem “--threads X”
+ Direktivou \#pragma omp parallel num_threads(X)	
+ Příkazem omp_set_num_threads(X)
+ Odnastavením proměnné prostředí OMP_THREAD_LIMIT
+ Nastavením proměnné prostředí “export OMP_NUM_THREADS=X,1,1”
+ Nastavením proměnnou prostředí “export OMP_THREAD_MAX=X”

#pagebreak()

*10. Uvažujme následující příklad:*\
#figure(
  image("resources/obr02.png", height: 25%, fit: "stretch"),
)
+ Dojde k uváznutí (deadlock)
+ Nedojde k uváznutí

*11. Pro použití podpory paralelismu v algoritmu standardní šablonové knihovny STL je potřeba:*\
+ Volat objekt třídy std::execution::seq s parametrem algoritmu
+ Volat objekt třídy std::execution::par s parametrem algoritmu
+ Instanciovat objekt třídy std::execution::seq a ten předat algoritmu
+ Předat objekt std::execution::seq algoritmu
+ Předat objekt std::execution::par algoritmu
+ Instanciovat objekt třídy std::execution::par a ten předat algoritmu

*12. Uvažujme následující příklad:*\
#figure(
  image("resources/obr03.png", height: 10%, fit: "stretch"),
)
Která tvrzení platí:
+ Ve dvou vláknech vytvořených direktivou parallel není zřejmé, jakou bude mít proměnná b hodnotu. Bude inicializovaná na 42
+ Ve dvou vláknech vytvořených direktivou parallel není zřejmé, jakou bude mít proměnná b hodnotu. Bude inicializovaná na 1
+ Ve dvou vláknech vytvořených direktivou parallel není zřejmé, jakou bude mít proměnná b hodnotu. Bude ale sdílena.
+ V hlavním vlákně není zřejmé, jakou bude mít proměnná b hodnotu před během bloku za direktivou parallel.
+ Ve dvou vláknech vytvořených direktivou parallel není zřejmé, jakou bude mít proměnná b hodnotu. Nebude ale sdílena.
+ V hlavním vlákně není zřejmé, jakou bude mít proměnná b hodnotu po běhu bloku za direktivou parallel

#pagebreak()

*13. Uvažujme kód:*\
#figure(
  image("resources/obr04.png", height: 25%, fit: "stretch"),
)
+ Nedojde k uváznutí, protože mutex nebude odemčen
+ Nedojde k uváznutí, protože mutex m1 bude odemčen dvakrát
+ Dojde k uváznutí, protože mutex nikdy nebude odemčen
+ Dojde k uváznutí, protože mutex bude odemčen dvakrát
+ Nedojde k uváznutí, protože mutex nikdy nebude zamčen

*14. Pokud pracujeme s std::thread exportovanou hlavičkou thread:*\

+ Vlákno začne běžet po zavolání konstruktoru a metody call
+ Vlákno začne běžet bezprostředně po zavolání konstruktoru
+ Vlákno začne běžet po zavolání konstruktoru a metody join
+ Vlákno začne běžet po zavolání konstruktoru a metody run

*15. Návratovou hodnotu vlákna mohu získat:*\
+ Při použití hlavičky thread, pomocí method get() třídy std::jthread
+ Při použití hlavičky future, pomocí metody get() třídy std::launch
+ Při použití hlavičky future, pomocí metody get() třídy std::future
+ Při použití hlavičky thread, pomocí metody get() třídy std::thread
+ Při použití hlavičky future, pomocí metody get() třídy std::async
+ Při použití hlavičky future, pomocí metody get() třídy std::thread

*16. Direktiva \#pragma omp parallel vytvoří:*\

+ Tým vláken, která se připojí k hlavnímu vláknu (join) po konci následujícího bloku
+ Tým vláken, která se připojí k hlavnímu vláknu (join) po konci tohoto bloku
+ Tým vláken, která je potřeba explicitně připojit (join) k hlavnímu vláknu

#pagebreak()

*17. Uvažujme následující příklad:*\
#figure(
  image("resources/obr05.png", height: 25%, fit: "stretch"),
)
+ Kód nepovede k uváznutí, pokud dojde k neošetřené výjimce ve volání A(). Neošetřená výjimka ve volání B() to nemůže ovlivnit.
+ Kód povede k uváznutí. Nezmění na tom nic ani neošetřená výjimka vyvolaná voláním v A(), ani neošetřená výjimka ve volání B().
+ Kód povede k uváznutí, pokud dojde k neošetřené výjimce ve volání A(). Neošetřená výjimka ve volání B() to nemůže ovlivnit.
+ Kód povede k uváznutí, pokud dojde k neošetřené výjimce ve volání B(). Neošetřená výjimka ve volání A() to nemůže ovlivnit.
+ Kód nepovede k uváznutí. Nezmění na tom nic ani neošetřená výjimka vyvolaná voláním v A(), ani neošetřená výjimka ve volání B().

*18. V distribuovaném systému sestávajícím ze čtyř procesů běží algoritmus Bully pro volbu lídra, přičemž jako volební kritérium slouží identifikátor procesu (tj. Proces P4 má nejvyšší hodnotu volebního kritéria). V systému došlo k selhání dosavadního lídra P4 a proces P4 zůstává nadále nedostupný.*\
Předpokládejme, že selhání procesu P4 detekuje nejdříve proces P2, který následně spustí volbu lídra pomocí algoritmu Bully. Označte tvrzení týkající se následného průběhu algoritmu Bully:
+ P2 odešle zprávu ELECTION procesu P1
+ Ihned po přijetí zprávy ELECTION proces P3 pošle procesu P1 zprávu ELECTION
+ Po vypršení volebního time-out pošle proces P3 procesu P1 zprávu COORDINATOR(P3)
+ P2 odešle zprávu ELECTION procesu P3
+ Ihned po přijetí zprávy ELECTION proces P3 pošle procesu P4 zprávu ELECTION
+ Po vypršení volebního time-out pošle proces P3 procesu P2 zprávu OK
+ Po vypršení volebního time-out pošle proces P3 procesu P1 zprávu OK
+ Ihned po přijetí zprávy ELECTION proces P3 pošle procesu P1 zprávu OK
+ Po vypršení volebního time-out pošle proces P3 procesu P2 zprávu COORDINATOR(P3)
+ Po vypršení volebního time-out pošle proces P3 procesu P4 zprávu COORDINATOR(P3)
+ Ihned po přijetí zprávy ELECTION proces P3 pošle procesu P2 zprávu OK

#pagebreak()

*19. V distribuovaném systému sestávajícím ze #underline[čtyř] procesů běží algoritmus Bully pro volbu lídra. V systému došlo k selhání lídra, které bylo detekováno jedním z procesů a tento proces se chystá zahájit volbu lídra. Předpokládejme, že v systému od tohoto okamžiku nebude docházet k dalším selhání (procesu ani kanálu). Timeout $T_"OK"$ označuje časový interval, po který proces po odeslání zprávy ELECTION čeká na zprávu OK předtím, než se prohlásí za kandidáta na lídra a odešle zprávu COORDINATOR. V systému není k dispozici nativní multicast.*\
Označte pravdivá tvrzení týkající se komunikační složitosti a latence následného průběhu algoritmu Bully:
+ Během volby lídra bude v nejlepším případě v systému odesláno 5 zpráv
+ Během volby lídra bude v nejhorším případě v systému odesláno 11 zpráv
+ Během volby lídra budou v nejlepším případě v systému odeslány 2 zprávy
+ Volba lídra může v nejhorším případě trvat 1 komunikační latenci + $T_"OK"$
+ Během volby lídra budou v nejlepším případě v systému odeslány 4 zprávy
+ Volba lídra může v nejhorším případě trvat 2 komunikační latence + $T_"OK"$
+ Během volby lídra bude v nejhorším případě v systému odesláno 31 zpráv
+ Volba lídra může v nejhorším případě trvat 3 komunikační latence + $T_"OK"$
+ Během volby lídra budou v nejhorším případě v systému odesláno 19 zpráv

*20. V distribuovaném systému sestávajícím ze #underline[pěti] procesů běží algoritmus Bully pro volbu lídra. V systému došlo k selhání lídra, které bylo detekováno jedním z procesů a tento proces se chystá zahájit volbu lídra. Předpokládejme, že v systému od tohoto okamžiku nebude docházet k dalším selhání (procesu ani kanálu). Timeout $T_"OK"$ označuje časový interval, po který proces po odeslání zprávy ELECTION čeká na zprávu OK předtím, než se prohlásí za kandidáta na lídra a odešle zprávu COORDINATOR. V systému není k dispozici nativní multicast.*\
Označte pravdivá tvrzení týkající se komunikační složitosti a latence následného průběhu algoritmu Bully:
+ Během volby lídra bude v nejlepším případě v systému odesláno 5 zpráv
+ Během volby lídra bude v nejhorším případě v systému odesláno 11 zpráv
+ Během volby lídra budou v nejlepším případě v systému odeslány 2 zprávy
+ Volba lídra může v nejhorším případě trvat 1 komunikační latenci + $T_"OK"$
+ Během volby lídra budou v nejlepším případě v systému odeslány 4 zprávy
+ Volba lídra může v nejhorším případě trvat 2 komunikační latence + $T_"OK"$
+ Během volby lídra bude v nejhorším případě v systému odesláno 31 zpráv
+ Volba lídra může v nejhorším případě trvat 3 komunikační latence + $T_"OK"$
+ Během volby lídra budou v nejhorším případě v systému odesláno 19 zpráv

#pagebreak()

*21. Na obrázku jsou zachyceny tři řezy distribuovaného výpočtu:*\
#figure(
  image("resources/obr06.png", height: 25%, fit: "stretch"),
)
Předpokládejme, že externí pozorovatel má v jakémkoliv fyzickém časovém okamžiku okamžitý přístup ke stavu všech procesů a všech kanálů. Označte všechna pravdivá tvrzení:\
+ Řez R1 je konzistentní řez
+ Řez R2 mohl být pozorován externím pozorovatelem
+ Řez R3 je konzistentní řez
+ Řez R2 je konzistentní řez
+ Řez R3 mohl být pozorován externím pozorovatelem
+ Řez R1 mohl být pozorován externím pozorovatelem

*22. Označte pravdivá tvrzení týkající se možného využití Chandy-Lamportova algoritmu pro výpočet globálního snapshotu. (Pozn.: předpokládejte, že ve výpočtu nedochází k selháním procesů ani kanálů). Chandy-Lamportův algoritmus umožňuje:*\
+ Spolehlivě z vypočteného snapshotu identifikovat objekty, na které aktuálně v systému globálně neexistuje žádná reference (např. za účelem následné garbage collection)
+ Spolehlivě z vypočteného snapshotu detekovat, že ve výpočtu probíhá volba lídra
+ Spolehlivě z vypočteného snapshotu detekovat, že výpočet uváznul
+ Spolehlivě z vypočteného snapshotu detekovat, že v algoritmu RAFT mají procesy vzájemně nekonzistentní logy
+ Spolehlivě z vypočteného snapshotu detekovat, že výpočet skončil (ukončení výpočtu)
+ Spolehlivě z vypočteného snapshotu detekovat, že ve výpočtu čeká alespoň jeden proces na vstup do kritické sekce

#pagebreak()

*23. Označte všechny dvojice logů, které se mohou vyskytnout v průběhu algoritmu RAFT.*\
#figure(
  image("resources/obr07.png", height: 25%, fit: "stretch"),
)
+ L7
+ L6
+ L4
+ L1
+ L5
+ L2
+ L3

*24. Skupina 4 procesů P1, P2, P3, P4 vykonává algoritmus Ricart-Agrawala pro vyloučení procesů. Žádný z procesů není aktuálně v kritické sekci (KS) a ani o vstup nepožádal a v přenosu není žádná zpráva. Uvažujme, že proces P1 právě vykonal operaci enter() pro vstup do KS. Předpokládejme, že doba přenosu zpráv je přesně 100ms, že procesy reagují na příchozí zprávy okamžitě a že v systému nejsou posílány žádné jiné zprávy než zprávy samotného algoritmu Ricart-Agrawala a že systém nepodporuje nativní multicast.* \

+ P1 bude muset na vstup do KS od vyvolání operace enter() počkat 300 ms.
+ Od vyvolání operace enter() pro vstup do KS do ukončení operace exit() pro opuštění KS budou v algoritmu odeslány celkem 3 zprávy
+ P1 bude muset na vstup do KS od vyvolání operace enter() počkat 100 ms
+ Po vstupu do kritické sekce musí proces P1 odeslat všem ostatním procesům zprávu HELD.
+ Od vyvolání operace enter() pro vstup do KS do ukončení operace exit() pro opuštění KS budou v algoritmu odesláno celkem 6 zpráv
+ P1 bude muset na vstup do KS od vyvolání operace enter() počkat 200 ms
+ Před vstupem do kritické sekce musí proces P1 odeslat všem ostatním procesům zprávu WANTED.
+ Před vstupem do kritické sekce musí proces P1 odeslat všem ostatním procesům zprávu REQUEST.
+ Od vyvolání operace enter() pro vstup do KS do ukončení operace exit() pro opuštění KS budou v algoritmu odesláno celkem 9 zpráv
+ Před vstupem do kritické sekce musí proces P1 obdržet od všech ostatních procesů zprávu OK.
+ Po výstupu z kritické sekce musí proces P1 odeslat všem ostatním procesům zprávu OK.
+ Před vstupem do kritické sekce může proces P1 obdržet od některého z ostatních procesů zprávu WAIT.

#pagebreak()

*25. Následující tvrzení se týkají úplnosti třech různých detektorů selhání běžících v distribuovaném systému sestávajícího z 10 procesů. Pro každý z detektorů definujme stupeň robustnosti jako maximální číslo N takové, že daný detektor zůstane úplný, pokud v systému neselže současně více než N libovolných procesů (a tedy že pokud selže N+1 procesů, tak úplnost již garantovat nelze)*\
Označte výroky, které označují správnou hodnotu stupně robustnosti pro každého z detektorů:
+ Stupeň robustnosti oboustranného kruhového heartbeat detektoru je 3
+ Stupeň robustnosti oboustranného kruhového heartbeat detektoru je 1
+ Stupeň robustnosti SWIM detektoru s K=3 je 1
+ Stupeň robustnosti oboustranného kruhového heartbeat detektoru je 2
+ Stupeň robustnosti centralizovaného heartbeat detektoru je 1
+ Stupeň robustnosti centralizovaného heartbeat detektoru je 9
+ Stupeň robustnosti SWIM detektoru s K=3 je 3
+ Stupeň robustnosti centralizovaného heartbeat detektoru je 0
+ Stupeň robustnosti SWIM detektoru s K=3 je 9

*26. Uvažujme příklad*\
#figure(
  image("resources/obr08.png", height: 48%, fit: "stretch"),
)
+ První bude vypsáno písmeno c
+ První bude vypsáno písmeno B
+ První bude vypsáno písmeno a
+ První bude vypsáno písmeno b
+ První bude vypsáno písmeno A
+ První bude vypsáno písmeno C
+ První písmeno není možné určit

#pagebreak()

*27. V distribuovaném systému byl spuštěn Chandy-Lamportův algoritmus pro výpočet globálního snapshotu. Aktuální stav běhu algoritmu je zachycen na obrázku níže:*\
#figure(
  image("resources/obr09.png", height: 40%, fit: "stretch"),
)
Uvažujme akce, které jednotlivé procesy provedou bezprostředně jako další krok Chandy-Lamportova algoritmu (procesy mohou v dalším kroku provést i několik akcí najednou):
+ Proces P1 spustí záznam příchozích zpráv na kanále P1 -> P3
+ Proces P1 zaznamenává svůj lokální stav
+ Proces P1 odešle zprávu ZNAČKA procesu P2
+ Proces P1 odešle zprávu ZNAČKA procesu P3
+ Proces P1 spustí záznam příchozích zpráv na kanále P3 -> P1
+ Proces P2 odešle zprávu ZNAČKA procesu P1
+ Proces P1 zastaví záznam příchozích zpráv na kanále P2 -> P1
+ Proces P2 zaznamenává svůj lokální stav
+ Proces P1 zastaví záznam příchozích zpráv na kanále P3 -> P1
+ Proces P2 odešle zprávu ZNAČKA procesu P3

*28. OpenMP je:*\
+ Knihovna libgomp
+ Organizace
+ Podfuk
+ Program
+ Překladač
+ Specifikace
+ Magie

#pagebreak()

*29. Uvažujme dva kousky kódu:*\
#figure(
  image("resources/obr10.png", height: 20%, fit: "stretch"),
)
+ Chování obou příkladů bude stejné a nekorektní. Může dojít k problémům se souběhem (race condition)
+ Chování obou příkladů bude stejné a korektní. Nemůže dojít k problémům se souběhem (race condition)
+ Chování prvního příkladu bude nekorektní, zatímco ve druhém příkladu může dojít k problémům se souběhem (race condition)
+ Chování druhého příkladu bude nekorektní, zatímco v prvním příkladu může dojít k problémům se souběhem (race condition)

*30. Pokud chceme v C++ pracovat s mutexy, které konstrukce umožní s nimi pracovat tak, aby případná výjimka v kódu nezpůsobila uváznutí?*\
+ std::lock_guard
+ std::unique_lock
+ std::mutex
+ Vlastní implementace schématu „Resource Acquisition Is Initialization” (RAII)

*31. Co je špatně na následujícím kousku kódu (se standardními hlavičkami iostream, thread, vector):*\
#figure(
  image("resources/obr11.png", height: 20%, fit: "stretch"),
)
+ Kód je celý v pořádku
+ Kód má používat standardní hlavičku jthread, nikoli thread
+ Kód nepoužije volání metody join, a tudíž neuvolní paměť
+ Vlákna nikdy nezačnou běžet, protože po konstruktoru nebude zavolána metoda run
+ Více vláken než počet jader procesorů může vést k uváznutí

#pagebreak()

*32. Vyberte všechny správné odpovědi. Pokud pracujeme s objektem třídy std::thread exportovanou standardní hlavičkou thread, objekt je:*\
+ CopyConstructible
+ CopyAssignable
+ Nic z toho
+ MoveConstructible
+ TriviallyCopyConstructible

*33. Uvažujme kód se standardními hlavičkami iostream, thread:*\
#figure(
  image("resources/obr12.png", height: 30%, fit: "stretch"),
)
Jaký bude výstup?
+ Hodnota 3 nebo 2 nebo 1
+ Hodnota 3
+ Hodnota 2 nebo 1
+ Žádný výstup
+ Hodnota 0
+ Hodnota 3 nebo 2
+ Hodnota 2 nebo 1 nebo 0

#pagebreak()

*34. Uvažujme následující kód*\
#figure(
  image("resources/obr13.png", height: 22%, fit: "stretch"),
)
+ Není jasné, zda se provedou method(1) a method(4) souběžně
+ Není jasné zda se method(2) a method(3) provedou souběžně. Závisí to na thread_count
+ method(1) doběhne před spuštěním method(3)
+ Není jasné, kolikrát bude spuštěna method(2). Závisí to na thread_count
+ Není jasné, zda se provedou method(2) a method(4) souběžně. Závisí to na thread_count
+ Není jasné, kolikrát bude spuštěna method(1). Závisí to na thread_count
+ method(1) doběhne před spuštěním method(2)
+ method(1) bude spuštěna právě jednou a nezávisí to na thread_count
+ method(1) doběhne před spuštěním method(4)
+ method(2) bude spuštěna právě jednou a nezávisí to na thread_count
+ Není jasné, zda se provedou method(1) a method(2) souběžně

*35. Uvažujme příklad s hlavičkami iostream, “omp.h”*\
#figure(
  image("resources/obr14.png", height: 30%, fit: "stretch"),
)
+ Výstup může být 010111
+ Výstup může být 001111
+ Výstup může být 0101
+ Výstup může být 0011
+ Výstup může být 00111111
+ Výstup může být 01011111

#pagebreak()

*36. Uvažujme příklad s hlavičkami iostream, “omp.h”*\
#figure(
  image("resources/obr15.png", height: 30%, fit: "stretch"),
)
Která tvrzení jsou správně:

+ Výstup může být 11002222
+ Výstup může být 10101010222222 (s povoleným vnořením)
+ Výstup může být 1010222222
+ Výstup může být 1100222222
+ Výstup může být 110022222222
+ Výstup může být 11110000222222 (s povoleným vnořením)
+ Výstup může být 10102222

*37. Třída std::mutex je definována v hlavičce:*\
+ chrono
+ mutex
+ thread

*38. Uvažujme použití hlavičky pthread.h a deklaraci pthread_t \*thread_handles. Jak pokračovat, abychom správně inicializovali thread_handles:*\
+ pthread_attr_init(&thread_handles[0]);
+ thread_handles = pthread_create(NULL, Hello, (void \*) thread);
+ thread_handles = (pthread_t\*)malloc(thread_count \* sizeof(pthread_t));
+ pthread_join(thread_handles(0), NULL);
+ pthread_create(&thread_handles(0), NULL);
+ (\*thread_handles);

#pagebreak()

*39. Označte všechny dvojice logů, které se mohou vyskytnout v průběhu algoritmu RAFT*\
#figure(
  image("resources/obr16.png", height: 30%, fit: "stretch"),
)
+ L1
+ L2
+ L7
+ L4
+ L3
+ L6
+ L5

*40. Následující tvrzení se týkají úplnosti třech různých detektorů selhání běžících v distribuovaném systému sestávajícího z 5 procesů. Pro každý z detektorů definujme stupeň robustnosti jako maximální číslo N takové, že daný detektor zůstane úplný, pokud v systému neselže současně více než N libovolných procesů (a tedy že pokud selže N+1 procesů, tak úplnost již garantovat nelze).*\
Označte výroky, které označují správnou hodnotu stupně robustnosti pro každého z detektorů:
+ Stupeň robustnosti jednostranného kruhového heartbeat detektoru je 0
+ Stupeň robustnosti jednostranného kruhového heartbeat detektoru je 2
+ Stupeň robustnosti SWIM detektoru s K=2 je 1
+ Stupeň robustnosti jednostranného kruhového heartbeat detektoru je 1
+ Stupeň robustnosti centralizovaného heartbeat detektoru je 1
+ Stupeň robustnosti centralizovaného heartbeat detektoru je 4
+ Stupeň robustnosti SWIM detektoru s K=2 je 4
+ Stupeň robustnosti centralizovaného heartbeat detektoru je 0
+ Stupeň robustnosti SWIM detektoru s K=2 je 2

*41. Uvažujme algoritmus RAFT pro distribuovaný konsenzus. Označte všechna pravdivá tvrzení týkající se průběhu algoritmu RAFT:*\
+ V každé epoše je v clusteru *právě jeden* proces ve stavu lídr
+ V každém fyzickém okamžiku je v clusteru *maximálně jeden* server ve stavu lídr
+ V každé epoše je v clusteru *maximálně jeden* proces ve stavu lídr
+ V každém fyzickém okamžiku je v clusteru *právě jeden* server ve stavu lídr

#pagebreak()

*42. Uvažujme následující kód: *\
#figure(
  image("resources/obr17.png", height: 20%, fit: "stretch"),
)
Která tvrzení jsou správné?
+ Nepůjde pravděpodobně zkompilovat
+ Paralelní blok skončí po nalezení prvního řešení
+ Paralelní blok skončí až všechna vlákna najdou řešení
+ Aby blok skončil ihned po nalezení řešení musímě (vhodně) doplnit `#pragma omp cancel for`
+ Aby blok skončil ihned po nalezení řešení musímě (vhodně) doplnit `#pragma omp cancelation point for`
+ Měli bychom nastavit proměnnou prostředí `OMP_CANCELLATION=true`

*43. Jakou roli hrají v distribuovaných systémech logické hodiny?*\
+ zajišťují, že všechny procesy mají stejný čas
+ mohou sloužit k detekci porušení kauzality
+ informují příjemce zprávy o hodinách odesílatele
+ vynucují totální uspořádání událostí v systému
+ určují reálný čas, kdy byla zpráva poslána

*44. Jaké vlastnosti mají vektorové hodiny?*\
+ jsou paměťově náročnější než skalární hodiny
+ dokáží detekovat porušení kauzality vůči konkrétnímu procesu
+ generují částečné uspořádání zpráv
+ určují reálný čas kdy byla zpráva poslána
+ dokáží detekovat zda je daná událost kauzálním důsledkem jiné události

*45. Které z následujících algoritmů distribuuvaného vzájemného vyloučení jsou férové?*\
+ Centrální server
+ Kruhové splňování
+ Ricard-Agrawalovo vyloučení

*46. Které z následujících algoritmů distribuuvaného vzájemného vyloučení je nejefektivnější z hlediska počtu poslaných zpráv? *\
+ Centrální server 
+ Kruhové splňování
+ Ricart-Agrawalovo vyloučení

#pagebreak()

*47. Jakým způsobem Raft zpracovává klientské požadavky?*\
Zvolte, které z následujících možností platí:
+ všechny požadavky splní
+ splní jen požadavky, které leader klientovi potvrdí
+ splní jen požadavky, které si zapíše do logu nadpoloviční většina serverů
+ potvrzené požadavky může ze svého logu mazat jen nový leader
+ nepotvrzené požadavky si může z logu smazat jakýkoli server
\
Komentář cvičícího:\
a)  Ne, například požadavky přijmuté nelídrem nejsou vůbec zaznamenány a všechny nepotvrzené leaderem mohou být ze systému smazány\
c)  Ne, splní jen požadavky jejichž přijetí leaderovi potvrdí nadpoloviční většina serverů\
e) Ano, na základě komunikace pomocí AppendEntrties s leaderem\

*48. Jakým způsobem Raft používá leadera?*\
Zvolte, které z následujících možností plati:
+ leader má vždy nejvyšší index z běžících procesů
+ kandidát na leadera musí mít nejnovější log
+ pouze leader může posílat požadavky o zápis do logů followerům
+ při výpadku leadera Raft přestane fungovat navždy
+ v systému může být vždy nanejvýš jeden leader
+ systém může být několik epoch bez leadera
\
Komentář cvičícího:\
+ Ne, volba leadera se nezakládá id serverů (id se používá pouze pro identifikaci odesílatelu a příjemcu zpráv)
+ Ne, kandidátem se může stát libovolný follower nebo kandidát. Ale server nedá hlas kandidátovi s méně aktuálním logem než má sám. Zvolený leader také nemusí mít nejnovější log, stačí aby byl aktuálnější než většina serverů
+ Ano, leader je zodpovědný za koordinaci zpracování požadavků a jako jediný může zapisovat do logů followerů
+ Ne, systém si zvolí nového leadera, který začne zpracovávat požadavky klientů
+ Záleží, v jednom _termu_ může být maximálně jeden leader, ale v jeden okamžik může být leaderů více
+ Ano, ve volbách nemusí být zvolen žádný leader (např. při rovnosti hlasů více kandidátů)
*49. Která z následujících tvrzení o false sharingu jsou pravdivá?*\
+ Může způsobit nekorektnosti (chybný výsledek) paralelního algoritmu
+ Vlákna přistupují k proměnným, ke kterým nemají práva
+ Je způsobený architekturou cache pamětí mnoderních procesorů
+ Dá se mu předcházet vhodnou prací s pamětí
+ Může způsobit degradaci výkonu paralelního algoritmu

#pagebreak()

*50. Uvažujme následující kód:*\
#figure(
  image("resources/obr18.png", height: 20%, fit: "stretch"),
)
Co může být po dokončení běhu v proměnné sum?\
\<Otevřená otázka>\
*51. Uvažujme následující kód:*\
#figure(
  image("resources/obr19.png", height: 30%, fit: "stretch"),
)
Jakého zrychlení programu dosáhneme paralelizací `for` smyčky (viz sekvenční implementace), když tato `for` smyčka trvá 70 % času běhu programu? Úlohu paralelizujeme na procesoru se čtyřmi jádry. Uvažujeme, že výpočty `slowFunctionToCompute` jsou nezávislé, a lze je proto dobře paralelizovat. Vyberte nejpravděpodobnonější:\
\<Výběr možností se nezachoval, takže následuje pouze korektní odpověď>
+ 0.9x zrychlení, protože použitý mutex nikdy neodemkneme a získáváme prakticky sériové řešení + navíc režii mutexu.

#pagebreak()

*52. Uvažujte následující kód:*
#figure(
  image("resources/obr20.png", height: 20%, fit: "stretch"),
)
Zvolte, co se může stát:
+ Kód nelze zkompilovat
+ OpenMP rozdělí práci na `for` cyklu mezi dostupná fyzická vlákna
+ Vnitřní smyčka bude provedena sériově
+ OpenMP vytvoří více vláken než fyzicky lze a dojde k degradaci výkonu
+ `for` smyčka bude provedena každým vláknem celá

*53. Uvažujte následující kód:*
#figure(
  image("resources/obr21.png", height: 20%, fit: "stretch"),
)
Zvolte, co se může stát:
+ Dojde k efektivní paralelizaci výpočtu
+ OpenMP zvládne distribuovat sčítání mezi vlákny, aby nedošlo k degradaci výkonu
+ OpenMP bude zbytečně často serializovat vlákna pomocí `critical`
+ OpenMP bude naprosto zbytečně serializovat vlákna pomocí `critical`

#pagebreak()

*54. Uvažujte následující kód:*
#figure(
  image("resources/obr22.png", height: 20%, fit: "stretch"),
)
Zvolte, které z následujících možností platí:
+ Kód nelze zkompilovat, protože globalMin není atomic a nelze na ní zavolat compare
+ Do globalMin se vždy uloží chunkMin
+ Do globalMin se uloží minCopy, pokud chunkMin není rovno minCopy
+ Do minCopy se uloží globalMin, pokud globalMin není rovno chunkMin
+ Do globalMin se uloží chunkMin, pokud globalMin není rovno minCopy
+ Kód vrací chybu, pokud globalMin není rovno minCopy

*55. Uvažujte následující kód:*
#figure(
  image("resources/obr23.png", height: 20%, fit: "stretch"),
)
+ Výpočet končí okamžitě po nalezení prvního řešení
+ Po nalezení prvního řešení výpočet skončí až všechna vlákna narází na `cancellation point`
+ Ani jedna z předchozích odpovědí není správna

#pagebreak()

*56. Uvažujme kód:*
#figure(
  image("resources/obr24.png", height: 15%, fit: "stretch"),
)
Která tvrzení jsou správná:
+ Korektní.
+ Chybný: Není možné instanciovat šablonovou třídu std::lock_guard s parametrem std::mutex. Je třeba std::lock nebo podtřída téhož.
+ Chybný: Třída std::mutex není podtřídou BasicLockable.
+ Chybný: Šablonová třída std::lock_guard není deklarována v hlavičkách thread a mutex.
+ Chybný: Mutex m nebude nikdy zamčen, i pokud bude volána procedura op. 
+ Chybný: Mutex m nebude nikdy odemčen, i pokud bude volána procedura op.
(Více než jedna odpověď může být správná)\
\
*57. Problém konsensu je _řešitelný_ v:*
+ synchronních distribuovaných systémech bez selhání (procesů i kanálů).
+ asynchronních distribuovaných systémech bez selhání (procesů i kanálů).
+ asynchronních distribuovaných systémech s fail-stop selháním procesů a bez selhání kanálů.
+ synchronních distribuovaných systémech s fail-stop selháním procesů a bez selhání kanálů.
\
*58. Doplňte stupně robustnosti pro následující detektory běžící v distribuovaném systému sestávajícího z #underline[8] procesů:*\
Definujme stupeň robustnosti detektoru selhání jako #underline[maximální] číslo N takové, že daný detektor zůstane úplný, pokud v systému neselže #underline[více než] N #underline[libovolných] procesů (a tedy že pokud selže N-první proces, tak úplnost již garantovat nelze). Uvažujte nejhorší možný případ co se týče procesů, které selhávají.

+ Stupeň robustnosti _centralizovaného heartbeat_ detektoru je ............
+ Stupeň robustnosti _jednostranného kruhového heartbeat_ detektoru je ............
+ Stupeň robustnosti _all-to-all heartbeat_ detektoru je ............
+ Stupeň robustnosti _SWIM_ detektoru s K=4 je ............
(V případě detektoru _SWIM_ označuje K počet procesů, které jsou vybírány pro nepřímý ping-req.)

#pagebreak()

*59.*
#figure(
  image("resources/obr26.png", height: 30%, fit: "stretch"),
)
Doplňte:
+ Hodnota skalárních hodin procesu P3 bezprostředně po události *K* bude ...............
+ Hodnota skalárních hodin procesu P2 bezprostředně po události *H* bude ...............
+ Hodnota vektorových hodin procesu P3 bezprostředně po události *K* bude ...............
+ Hodnota vektorových hodin procesu P2 bezprostředně po události *G* bude ...............

#pagebreak()

*60. Uvažujme kód:*
#figure(
  image("resources/obr25.png", height: 30%, fit: "stretch"),
)
Která tvrzení jsou správná:
+ použití bariéry povede k uváznutí (deadlock).
+ použití bariéry nepovede k uváznutí (deadlock).
+ je možné říct, kolik řádek bude vypsáno.
+ není možné říct, kolik řádek bude vypsáno. Závisí to na hardware a proměnných prostředí.
+ může dojít k problému souběhu (data race). Mezi vlákny bude sdíleno 32768 bytů paměti („buffer"), kterou používá printf, ale její použití není ošetřeno synchronizačními primitivy. Nahrazení režimu \_IOBF za \_IONBF ve volání setvbuf může dojít k omezení problému souběhu.
+ může dojít k problému souběhu (data race). POSIX nám dává „thread-safe" záruky na volání jednotlivých funkcí, ale nezaručuje použití synchronizačních primitiv mezi dvěma voláními flockfile() a funlockfile() z jednoho vlákna.
+ nemůže dojít k problému souběhu (data race). Dojde k vypsání řádek ve správném pořadí, nezávisle na architektuře.
(Více než jedna odpověď může být správná)\

#pagebreak()

*61. Uvažujme následující kód:*
#figure(
  image("resources/obr27.png", height: 40%, fit: "stretch"),
)
Která tvrzení jsou správná:
+ použití bariéry povede k uváznutí (deadlock).
+ použití bariéry nepovede k uváznutí (deadlock).
+ je možné říct, kolik řádek bude vypsáno.
+ není možné říct, kolik řádek bude vypsáno. Závisí to na hardware a proměnných prostředí.
+ může dojít k problému souběhu (data race). Mezi vlákny bude sdílena paměť („buffer"), kterou používá osyncstream, ale její použití není ošetřeno synchronizačními primitivy.
+ může dojít k problému souběhu (data race). POSIX nám dává „thread-safe" záruky na volání jednotlivých funkcí, ale nezaručuje použití synchronizačních primitiv meziu dvěma voláními flockfile() a funlockfile() z jednoho vlákna.
+ nemůže dojít k problému souběhu (data race). Dojde k vypsání řádek ve správném pořadí, nezávisle na architektuře.
*62. Intel MKL:*
+ je knihovna, která umí paralelizovat numerickou lineární algebru mezi více vláken.
+ je knihovna, která neumí paralelizovat numerickou lineární algebru mezi více vláken mezi několik procesorů, ale podporuje akcelerátory (GPGPU).
+ využívá OpenMP pro vícevláknový kód. Například volání `mkl_set_num_threads()` přepíše hodnotu nastavenou `omp_set_num_threads()`.
+ je nezávislá na OpenMP. Je možné ji kombinovat s OpenMP.
+ se vylučuje s OpenMP. Není možné ji kombinovat s OpenMP.

#pagebreak()

*63. Kritická sekce:*
+ je nástroj, kterým můžeme odstranit problém falešeného sdílení (false sharing).
+ je nástroj, kterým nemůžeme odstranit problém falešeného sdílení (false sharing).
+ je nástroj, kterým je možné odstranit problém souběhu (race condition).
+ je nástroj, kterým není možné odstranit problém souběhu (race condition).
+ je nástroj, který může způsobit problém hladovění (starvation), pokud je vláknu opakovaně bráněno ve vstupu do kritické sekce a kritická sekce je držena neobvykle dlouhou dobu nebo pokud má blákno s vysokou prioritou vždy přednost přti vstupu do kritické sekce.
+ je nástroj, který nemůže způsobit problém hladovění (starvation).
+ je nástroj, který sám o sobě může způsobit problém uváznutí (deadlock).
+ je nástroj, který sám o sobě nemůže způsobit problém uváznutí (deadlock).
+ je nástroj, který může být implementován zámky (lock) nebo mutexy.
+ je nástroj, který nemůže být implementován zámky (lock) nebo mutexy.
+ je běžně používána na MS Windows (i v rámci Win32 API díky synchapi.h).
+ v OpenMP může být kritická sekce sdílena napříč několika _`parallel regions`_ (kusy kódu anotované `#pragma omp parallel`).
+ v OpenMP může být vnořená kritická sekce v jiné kritické sekci, jen pokud pojmenujeme mutex, který má být použit.
(Více než jedna odpověď je správná)

*64. Následující tvrzení se týkají třech různých detektorů selhání běžících v distribuovaném systému sestávajícího #underline[z deseti procesů]. Předpokládejme, že v systému v hodnoceném období _nedochází_ k selháním.*\
Doplňte:
+ Centralizované heartbeat detektor generuje každou periodu heartbeatu celkem ......... zpráv.
+ All-to-all heartbeat detektor generuje každou periodu heartbeatu celkem ......... zpráv.
+ SWIM detektor s $K=2$ generuje každou periodu protokolu celkem ......... zpráv.

*65. Uvažujte centralizovaný algoritmus pro vyloučení procesů běžící v distribuovaném systému sestávajícím z 10 procesů (z nichž jeden je lídr).*\
Doplňte:
+ Pro vstup do kritické sekce je potřeba odeslat tento počet zpráv: .........
+ Zpoždění klienta je tento počet komunikačních latencí: .........
+ Synchronizační zpoždění je tento počet komunikačních latencí: .........

*66. Označte všechna pravdivá tvrzení:*\
V částečně synchronním systému:
+ Je doba doručení zpráv vždy shora omezená (danou maximální latencí).
+ Může být doba doručení zpráv libovolně velká.
+ Může být doba doručení zpráv nekonečně velká.
+ Je doba doručení zpráv většinou shora omezená (danou maximální latencí).
+ Se vyskytují dostatečně dlouhé časové intervaly, během kterých se systém chová jako synchronní systém.

#pagebreak()

*67. Označte všechny pravdivé výroky*\
V distribuovaném clusteru běží algoritmus Raft pro replikaci stavu výpočtu mezi jednotlivými servery. Předpokládejme, že volební timeout je nastaven na *300--500ms* a že všechny dřívější příkazy byly zreplikovány.
+ Bezprostředně po přijetí příkazu od klienta lídr příkaz vykoná a výsledek zapíše do svého logu.
+ Bezprostředně po přijetí příkazu od klienta lídr příkaz uloží do svého logu a pošle zprávu `AppendEntries` následovníkům.
+ Před zápisem příkazu od klienta do svého logu čeká lídr na potvrzení zprávy `AppendEntries` od následovníků.
+ Po vykonání příkazu od klienta zvýší lídr číslo epochy.
+ Neobdrží-li některý z následovníků od aktuálního lídra ani jednu zprávu `AppendEntries` (i prázdnou) do 500ms, vyvolá nové volby.
+ Pokud lídr neobdrží, od některého z následovníků potvrzení zprávy `AppendEntries` do 500ms, tak vyvolá nové volby.
+ Po přijetí příkazu od klienta lídr zvýší číslo epochy.
+ Bezprostředně po přijetí zprávy `AppendEntries` od lídra předají následovníci příkaz k vykonání svému stavovému automatu.
+ Jakmile je příkaz považován za potvrzený, tak je vykonán stavovým automatem lídra a výsledek je poslán klientovi.
+ Jakmile je příkazy vykonán stavovým automatem lídra, lídr přidá informaci o potvrzení (commit) do následující zprávy `AppendEntries` pro následovníky.
+ Neobdrží-li klient od clusteru na svůj příkaz odpověď do 500ms, vyvolá nové volby.

*68. Doplňte:*\
Proces _P_ používá Cristianův algoritmus pro synchronizaci fyzikálních hodin. Proces _P_ odeslal v lokálním čase *8h:50m:12.100s* s požadavkem na synchronizaci času k externím hodinám. V lokálním čase *8h:50m:12.260s* obdržel proces _P_ od externích hodin zpět zprávu s časem externích hodin *8h:50m:12.150s*. Minimální latence komunikace od _P_ k externím hodinám je *20ms* a minimální latence komunikace od externích hodin k procesu _P_ je *60ms*.
+ _P_ si má přenastavit svůj lokální čas na hodnotu ........................
+ Maximální odchylka času v procesu _P_ a času externích hodin je ........................

#pagebreak()

*69. V distribuovaném systému byl spuštěn Chandy-Lamportův algoritmus pro výpočet globálního snapshotu. Aktuální stav běhu algoritmu je zachycen na obrázku níže.* \
#figure(
  image("resources/obr28.png", height: 40%, fit: "stretch"),
)
Uvažujme operace, které jednotlivé procesy provedou jako další krok Chandy-Lamportova algoritmu, tj. operace, které procesy uvedou od aktuálního okamžiku (označeného na obrázku svislou čárkovanou čarou) do další aplikační události v daném procesu. Procesy mohou v tomto dalším kroku provést i několik operací najednou. \
*Doplňte:*\
+ Proces $P_1$ v dalším kroku provede následující operace: ........................
+ Proces $P_2$ v dalším kroku provede následující operace: ........................
+ Proces $P_3$ v dalším kroku provede následující operace: ........................

(Uvažované operace Chandy-Lamportova algoritmu: odeslání zprávy ZNAČKA procesu $P_i$, spuštění záznamu na kanále $P_i -> P_j$, zaznamenání lokálního stavu procesu. Pokud neprovede v dalším kroku proces žádnou operaci, uveďte _žádná operace_.)

#pagebreak()

*70. Uvažujme následující kousek kódu:*
#figure(
  image("resources/obr30.png", height: 15%, fit: "stretch"),
)
Předpokládejme, že operace `compare_swap` je zaručeně atomická.\
Označte všechny správné odpovědi. Více než jedna odpověď je správná. Všechny části odpovědi musí být správné, aby byla odpověď správná.
+ Máme atomickou operaci `compare_swap` a nepotrřebujeme další synchronizační primitiva pro ošetření přístupu do paměti. Nemůže dojít k uváznutí (deadlock) při paralelizaci for smyčky.
+ Potřebujeme další synchronizační primitiva pro ošetření přístupu do paměti při paralelizaci for smyčky. Pokud bychom hodnotu change aktualizovali s použitím zámků (lock) nebo mutexů po prvcích kontejneru `vector_to_sort`, může dojít k problému uváznutí (deadlock).
+ Potřebujeme další synchronizační primitiva pro ošetření přístupu do paměti při paralelizaci for smyčky. Pokud bychom hodnotu change aktualizovali s použitím zámků (lock) nebo mutexů po prvcích kontejneru `vector_to_sort` s použitím zámků `std::lock_guard`, nemůže dojít k problému uváznutí (deadlock).
+ Potřebujeme další synchronizační primitiva pro ošetření přístupu do paměti při paralelizaci for smyčky. Pokud bychom hodnotu change aktualizovali s použitím zámků (lock) nebo mutexů po prvcích kontejneru `vector_to_sort` s použitím zámků `std::scoped_lock`, také by nemohlo dojít k problému uváznutí (deadlock).
+ Potřebujeme další synchronizační primitiva pro ošetření přístupu do paměti při paralelizaci for smyčky. Pokud bychom hodnotu change aktualizovali s použitím zámku (lock) nebo mutexu na `change`, nemůže dojít k uváznutí.

#pagebreak()

*71. Uvažujme následující příklad.* \
Označte všechny správné odpovědi za předpokladu, že:
- implementace OpenMP podporuje vytvoření dvou vláken (ať už hardwarových nebo user-space),
- procesor podporuje vytvoření dvou vláken
- překládáte s `-std=c++20 -fopenmp`.
#figure(
  image("resources/obr31.png", height: 25%, fit: "stretch"),
)
+ Kód není možné přeložit.
+ Kód je možné přeložit, výstup ale není definován.
+ Kód je možné přeložit. Výstupem bude `aabbcc`.
+ Kód je možné přeložit. Výstupem bude `abcabc`.
+ Je možné říct, kolik vláken bude použito.
+ Není možné říct, kolik vláken bude použito.
+ Může dojít k problému uváznutí (deadlock).
+ Nemůže dojít k problému uváznutí (deadlock).
+ Může dojít k problému souběhu (race condition).
+ Nemůže dojít k problému souběhu (race condition).
(Více než jedna odpověď je správná.)

#pagebreak()

*72. Uvažujme následující příklad. Označte všechny správné odpovědi:*
#figure(
  image("resources/obr32.png", height: 50%, fit: "stretch"),
)
+ kód nemůže trpět problémem uváznutí.
+ kód může trpět problémem uváznutí a ten bychom mohli vyřešit použitím `std::scoped_lock` místo `std::unique_lock`.
+ kód může trpět problémem uváznutí a ten bychom _*NE*_\mohli vyřešit použitím `std::scoped_lock` místo `std::unique_lock`.
+ není možné instanciovat šablonovou třídu `std::unique_lock` s parametrem typu `std::mutex`. Je třeba `std::lock` nebo obecněji implementace `BasicLockable`.
+ mutex nikdy nebude vlastněný, protože nikdy nebude inicializován: je pouze deklarován ve struktuře Shared.
+ mutex nikdy nebude vlastněný, protože u objektů třídy jthread není volána metoda `run`.
+ mutex bude vlastněný, ale nebude uvolněný, protože není volána metoda `release`.
+ mutex je uvolněný v destruktoru. Nemusíme volat metoda `release`.
(Více než jedna odpověď může být správná.)

#pagebreak()

*73. V distribuovaném výpočtu zachyceném úplně na obrázku uvažujme uspořádání událostí.*
#figure(
  image("resources/obr29.png", height: 30%, fit: "stretch"),
)
Označte všechny výroky, které jsou pravdivé vzhledem k uspořádání dle relace #underline[stalo se před]:
+ Událost *F* se stala před událostí *L*.
+ *D* a *L* jsou souběžné události.
+ Událost *I* se stala před událostí *E*.
+ O kauzálním vztahu událostí *I* a *H* nelze rozhodnout.
+ *C* a *G* jsou souběžné události. 
+ Událost *C* se stala před událostí *K*.
+ O kauzálním vztahu událostí *B* a *G* nelze rozhodnout.
+ *I* a *H* jsou souběžné události.

#pagebreak()

= Autorství
Původní dokument byl vytvořen společnými silami studentů PDV v běhu léta páně 2022/2023. Následujícího běhu se dokument stal vylepšeným, opraveným, zkrášleným, větším a _doplň libovolné positivní adjektivum_.\
Nutno přese vše dodat, že, ačkoliv byl tento soubor mnohými lidmi studován a kontrolován, chyby se stále mohou vyskytovat. Tam, kde jsou odpovědi sporné, byla u odpovědi uvedena i myšlenka, proč je tato odpověď správná.\
Nikdo ze studentstva a už vůbec nikdo z přednášejících neručí za mentální zdraví budoucích studentů předmětu paralelních a distribuovaných systémů.\
= Poznámky pod čarou
Mějte na paměti, že kolega Mareček neaplikuje metody paralelismu na opravu zkouškových testů, a tedy je běžnou praxí, že testy skutečně opravuje klidně 10 dní. U teorie si nicméně můžete napsat další termín i bez toho, aniž byste měli oznámkovaný ten první. Uzná se vám pak nejlepší výkon.\

U otázek, kde odpovědi úplně chybí, platí, že byly čerstvě přidány a ještě nikdo nedostal dostatek odvahy doplnit korektní odpověď.



/* 
 * Pro účely kopírování 12 odrážek:
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 
+ 

*/