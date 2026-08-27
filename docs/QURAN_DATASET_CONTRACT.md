# Kur’an Dataset Sözleşmesi

Bu belge İslami Hayat uygulamasındaki Arapça Kur’an ana metninin production’a girebilmesi için zorunlu teknik ve lisans kurallarını tanımlar.

## Sabitlenen ana kaynak

- Kaynak: **Tanzil Project**
- Metin ailesi: **Uthmani**
- Kaynak sürümü: **Tanzil Quran Text v1.1**
- Resmî indirme belgesi: https://tanzil.net/docs/download
- Resmî indirme alan adı: `https://tanzil.net/`
- Lisans: **Creative Commons Attribution 3.0**
- Resmî lisans: https://tanzil.net/docs/Text_License
- Kaynak attribution: uygulamadaki Kaynaklar ve Lisanslar ekranında `Tanzil Project` açıkça gösterilecek ve `tanzil.net` bağlantısı verilecektir.

Tanzil’in 27 Ağustos 2026 tarihinde erişilebilen resmî indirme sayfası, en güncel metin sürümünü v1.1 olarak gösterir. Lisans sayfası verbatim kopyalama/dağıtıma izin verir fakat Kur’an metninin değiştirilmesini yasaklar.

## Değiştirilemez kaynak kuralı

Tanzil lisansı Kur’an metninin verbatim kopyalanıp dağıtılmasına izin verir fakat metnin değiştirilmesine izin vermez. Bu nedenle:

1. İndirilen ana Arapça metin salt-okunur kaynak asset olarak tutulur.
2. Harf, hareke, vakıf işareti veya ayet metni üzerinde otomatik “düzeltme” yapılmaz.
3. Arama/karşılaştırma için normalization gerekiyorsa yalnız ayrı, türetilmiş arama indeksinde yapılır; gösterilen canonical text değişmez.
4. Besmele gibi presentation ayrıştırmaları canonical asseti yeniden yazmaz; UI katmanında ele alınır.
5. Her release’te canonical dosyanın SHA-256 değeri manifestte sabitlenir ve runtime fail-closed integrity katmanıyla doğrulanır.
6. LF/CRLF veya Unicode normalizasyonu canonical dosyaya uygulanmaz; SHA-256 **exact indirilen bytes** üzerinden hesaplanır.

## Resmî indirme ve import hattı

Repo içindeki `scripts/fetch_tanzil_uthmani.py` yalnız `https://tanzil.net/` alan adından indirmeye izin verir. Akış:

1. Tanzil’den Uthmani kaynak dosyasını indirir.
2. Herhangi bir dönüştürme/yazım düzeltmesi yapmadan bellekte doğrular.
3. 114 sure / 6236 ayet yapısal kontrolü başarılı değilse dosyayı production asset olarak yazmaz.
4. Başarılı kaynak bytes’ını aynen `assets/quran/source/` alanına yazar.
5. Exact SHA-256, byte uzunluğu, sürüm, lisans ve provenance bilgisini JSON manifeste yazar.

Kaynak indirme sırasında mirror kullanılmaz. Bir redirect Tanzil dışı hosta giderse fetch işlemi fail-closed olur.

## Desteklenen kaynak düzenleri

`validate_quran_dataset.py` canonical bytes’ı değiştirmeden üç düzeni yapısal olarak okuyabilir:

- Tanzil plain text: her satır bir ayet, toplam 6236 satır.
- Numaralı text: `sura|ayah|text`.
- Eski test/import fixture uyumluluğu: `sura:ayah|text`.

Production için tercih **resmî Tanzil indirmesinden gelen dosyanın kendi düzenini aynen korumaktır**. Plain formatta sure/ayet locator’ları dosyaya yazılmaz; canonical 114-sure ayet tablosuna göre yalnız parser belleğinde türetilir. Bu nedenle metadata üretmek Kur’an source bytes’ını değiştirmez.

## Yapısal zorunluluklar

- UTF-8 olmalıdır.
- Tam veri seti **114 sure** içermelidir.
- Standart ayet numaralamasında toplam **6236 ayet** bulunmalıdır.
- Sure başına ayet sayıları `scripts/validate_quran_dataset.py` içindeki sabit canonical tabloyla birebir eşleşmelidir.
- Sura numarası 1–114 aralığında, ayet numarası o surenin geçerli aralığında olmalıdır.
- Numaralı formatta duplicate, sıra dışı veya eksik `sura:ayah` anahtarı production’ı bloklar.
- Boş ayet metni production’ı bloklar.
- Aynı dosyada karışık text layout production’ı bloklar.
- CRLF/LF farkı hash hesaplamasından önce normalize edilmez; release hash exact kaynak bytes üzerinden hesaplanır.

## Besmele ve ayet numarası güvenliği

Tanzil’in standart sırası 6236 ayet kaydı kullanır. Besmele gösterimi canonical ayet numaralarını değiştirecek biçimde ayrı ayet ekleyemez. Uygulama UI’sında besmele özel sunulacaksa bu yalnız presentation metadata ile yapılır; canonical source satırları değiştirilmez.

## Çeviriler ayrı lisans alanıdır

Tanzil Arapça Kur’an metninin CC BY 3.0 lisansı, Tanzil’de veya başka depolarda yer alan Türkçe/İngilizce meallerin ticari yeniden dağıtım hakkını otomatik olarak vermez. Bu uygulama reklam ve Lifetime PRO içereceği için TR/EN meal seçimi **ayrı ticari kullanım/yeniden dağıtım lisansı doğrulanmadan** production’a alınmayacaktır.

## Production gate

Aşağıdakilerin tümü sağlanmadan `TEST_MATRIX.md` D01/D02 PASS yapılamaz:

1. Exact Tanzil v1.1 Uthmani source asset repoya veya güvenli build asset kaynağına eklenmiş olmalı.
2. `validate_quran_dataset.py` gerçek dosyada PASS olmalı.
3. Kaynak SHA-256 manifestte kayıtlı olmalı.
4. Runtime integrity kontrolü gerçek asset üzerinde PASS olmalı.
5. 114 sure ve 6236 ayet otomatik testte doğrulanmalı.
6. Attribution/lisans metni uygulama içinde görünür olmalı.
7. Kaynak dosyada değişiklik yapılmadığı exact-byte hash ile kanıtlanmalı.

Bu sözleşmenin amacı “yaklaşık doğru” Kur’an datasını kabul etmek değil, kaynak bytes seviyesinde doğrulanabilir bir production zinciri oluşturmaktır.
