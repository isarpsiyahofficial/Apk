# Kur’an Dataset Sözleşmesi

Bu belge İslami Hayat uygulamasındaki Arapça Kur’an ana metninin production’a girebilmesi için zorunlu teknik ve lisans kurallarını tanımlar.

## Sabitlenen ana kaynak

- Kaynak: **Tanzil Project**
- Metin ailesi: **Uthmani**
- Kaynak sürümü: **Tanzil Quran Text v1.1**
- Resmî indirme belgesi: https://tanzil.net/docs/download
- Lisans: **Creative Commons Attribution 3.0**
- Resmî lisans: https://tanzil.net/docs/text_license
- Kaynak attribution: uygulamadaki Kaynaklar ve Lisanslar ekranında `Tanzil Project` açıkça gösterilecek ve `tanzil.net` bağlantısı verilecektir.

## Değiştirilemez kaynak kuralı

Tanzil lisansı Kur’an metninin verbatim kopyalanıp dağıtılmasına izin verir fakat metnin değiştirilmesine izin vermez. Bu nedenle:

1. İndirilen ana Arapça metin salt-okunur kaynak asset olarak tutulur.
2. Harf, hareke, vakıf işareti veya ayet metni üzerinde otomatik “düzeltme” yapılmaz.
3. Arama/karşılaştırma için normalization gerekiyorsa yalnız ayrı, türetilmiş arama indeksinde yapılır; gösterilen canonical text değişmez.
4. Besmele gibi presentation ayrıştırmaları canonical asseti yeniden yazmaz; UI katmanında ele alınır.
5. Her release’te canonical dosyanın SHA-256 değeri manifestte sabitlenir ve runtime fail-closed integrity katmanıyla doğrulanır.

## Yapısal zorunluluklar

- UTF-8 olmalıdır.
- Tam veri seti **114 sure** içermelidir.
- Standart ayet numaralamasında toplam **6236 ayet** bulunmalıdır.
- Sure başına ayet sayıları `scripts/validate_quran_dataset.py` içindeki sabit canonical tabloyla birebir eşleşmelidir.
- Her satır tam olarak bir `sura:ayah|text` kaydı olarak import pipeline’a verilmelidir.
- Sura numarası 1–114 aralığında, ayet numarası o surenin geçerli aralığında olmalıdır.
- Duplicate veya eksik `sura:ayah` anahtarı production’ı bloklar.
- Boş ayet metni production’ı bloklar.
- CRLF/LF farkı hash hesaplamasından önce keyfî biçimde normalize edilmez; release hash exact kaynak bytes üzerinden hesaplanır.

## Besmele ve ayet numarası güvenliği

Tanzil’in standart sıra/çeviri formatı 6236 ayet kaydı kullanır. Besmele gösterimi canonical ayet numaralarını değiştirecek biçimde ayrı ayet ekleyemez. Uygulama UI’sında besmele özel sunulacaksa bu yalnız presentation metadata ile yapılır; canonical source satırları değiştirilmez.

## Çeviriler ayrı lisans alanıdır

Tanzil Arapça Kur’an metninin CC BY 3.0 lisansı, Tanzil’de yer alan Türkçe/İngilizce meallerin ticari yeniden dağıtım hakkını otomatik olarak vermez. Bu uygulama reklam ve Lifetime PRO içereceği için TR/EN meal seçimi **ayrı ticari kullanım/yeniden dağıtım lisansı doğrulanmadan** production’a alınmayacaktır.

## Production gate

Aşağıdakilerin tümü sağlanmadan `TEST_MATRIX.md` D01/D02 PASS yapılamaz:

1. Exact Tanzil v1.1 Uthmani source asset repoya veya güvenli build asset kaynağına eklenmiş olmalı.
2. `validate_quran_dataset.py` gerçek dosyada PASS olmalı.
3. Kaynak SHA-256 manifestte kayıtlı olmalı.
4. Runtime integrity kontrolü gerçek asset üzerinde PASS olmalı.
5. 114 sure ve 6236 ayet otomatik testte doğrulanmalı.
6. Attribution/lisans metni uygulama içinde görünür olmalı.
7. Kaynak dosyada değişiklik yapılmadığı hash ile kanıtlanmalı.

Bu sözleşmenin amacı “yaklaşık doğru” Kur’an datasını kabul etmek değil, kaynak bytes seviyesinde doğrulanabilir bir production zinciri oluşturmaktır.
