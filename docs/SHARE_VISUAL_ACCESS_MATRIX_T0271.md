# T0271 — 100 Paylaşım Tasarımı Erişim Matrisi

Bu karar SPEC v1.2 delta içindeki 100 görsel hedefini FREE/Rewarded/PRO davranışına bağlar. Bu belge yalnız **erişim politikasını** kesinleştirir; Canva adaylarının lisans, AI durumu, yeniden dağıtım/export hakkı, dosya hash'i ve gerçek asset kabulü ayrı final kapılarıdır.

## Nihai V1 erişim dağılımı

| Slot | FREE | Rewarded | PRO |
|---|---|---|---|
| 001–003 | Sınırsız | Gerekmez / teklif edilmez | Sınırsız |
| 004–100 | Kilitli | Reklam başarıyla tamamlanırsa yalnız seçilen tasarım için 1 paylaşım | Sınırsız, rewarded teklif edilmez |

Toplam: **100 tasarım = 3 kalıcı FREE + 97 Rewarded/PRO**.

## Değişmez kurallar

- PRO, 100 slotun tamamını reklamsız ve rewarded gerektirmeden kullanır.
- FREE kullanıcı ilk üç slotu reklam izlemeksizin sınırsız kullanır.
- FREE kullanıcı 004–100 arasındaki bir slotu yalnız kullanıcı tarafından başlatılan rewarded akışı başarıyla tamamlanınca bir kez kullanabilir.
- Reward, yalnız tamamlanan reklam terminal durumunda oluşur; cancel/fail/no-fill ödül üretmez.
- Reward tek tasarıma bağlıdır, başka tasarıma taşınamaz ve ikinci kez tüketilemez.
- PRO geçişi mevcut reward'u tüketmez; PRO erişimi entitlement üzerinden gelir.
- 1–100 dışında tasarım ID/slotu fail-closed reddedilir.
- Bu matris, herhangi bir Canva adayının final asset olduğunu **kanıtlamaz**. Final asset kabulü lisans manifesti ve 4-format readability/crop kanıtı gerektirir.

## Stabil mantıksal kimlik

Slotlar `share-design-001` … `share-design-100` kimlikleriyle temsil edilir. Bunlar aday/final görsel dosya adına veya Canva başlığına bağlı değildir; böylece lisans filtresinden geçemeyen bir aday aynı slotta güvenli bir Canva Free alternatifiyle değiştirilebilir ve entitlement davranışı değişmez.

## Test kanıtı

`test/core/monetization/share_visual_access_matrix_t0271_test.dart` şunları doğrular:

- 3 FREE + 97 Rewarded/PRO dağılımı,
- FREE'nin ilk üç dışındaki tasarımlara rewardsuz erişememesi,
- PRO'nun 100/100 erişimi,
- T0269/T0270 ile gerçek tek-kullanımlık rewarded grant entegrasyonu,
- yanlış tasarım grant'inin fail-closed kalması,
- PRO erişiminin grant tüketmemesi,
- bilinmeyen slotların reddedilmesi.

`TEST_MATRIX.md` S15, gerçek lisanslı 100 final asset ve UI/cihaz davranışı tamamlanana kadar TODO kalmalıdır.
