# T0338 — Production Publication State Release Gate

## Amaç

Bu kapı, bir dini/tarihsel kaydın yalnız `approved` görünmesi veya production listesindeki ID ile eşleşmesi nedeniyle final pakete girmesini engeller. Release inventory fail-closed çalışır.

## Zorunlu koşullar

`ProductionPublicationGateT0338` bir kaydı ancak aşağıdaki koşulların tamamı sağlanıyorsa kabul eder:

- canonical production inventory ID'si exact olarak beklenir,
- ID boş değildir ve trim/normalizasyon sonrası başka bir ID ile çakışmaz,
- kaydın workflow statüsü exact `published` durumundadır; `approved` dahil diğer tüm durumlar reddedilir,
- shared governance kuralları geçer: bilinen source class, TR/EN/AR tam metin, en az bir source, pozitif version,
- record ID'leri production listesinde unique kalır,
- source ID'leri aynı kayıt içinde unique ve non-empty kalır,
- source title ve license ID boş değildir,
- `unknown` source class production'a giremez,
- her source kullanıcı/QA tarafından denetlenebilir bir locator veya URL taşır.

## Failure-path kapsamı

`test/production_publication_gate_t0338_test.dart` şu riskleri fail-closed doğrular:

- draft/research/religiousReview/languageReview/approved/withdrawn kayıt sızıntısı,
- unexpected veya missing canonical record,
- duplicate production record ID,
- whitespace sonrası canonical expected-ID collision,
- incomplete TR/EN/AR content,
- unknown record source status,
- duplicate source ID,
- boş source license metadata,
- unknown per-source class,
- locator ve URL'si birlikte olmayan inspect edilemez provenance.

## Tamamlama sınırı

Bu gate T0338'in teknik publication-state sınırını güçlendirir; dini içeriklerin editorial/native review ve alan-spesifik source doğrulamalarının yerine geçmez. D05–D12 gibi açık dini içerik kapıları ayrıca kapanmadan religious-content release final değildir.
