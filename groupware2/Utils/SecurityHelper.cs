using System;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace groupware2.Utils
{
    public class SecurityHelper
    {
        private const int SaltSize = 16; // 16바이트 Salt (128비트)
        private const int HashSize = 32; // 32바이트 Hash (256비트)
        private const int Iterations = 10000; // 반복 횟수 (보안성 높이기)

        public static string HashPassword(string password)
        {
            using (var rng = new RNGCryptoServiceProvider())
            {
                byte[] salt = new byte[SaltSize];
                rng.GetBytes(salt); // 랜덤 Salt 생성

                using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
                {
                    byte[] hash = pbkdf2.GetBytes(HashSize);

                    // salt + hash를 Base64로 변환해서 저장
                    return Convert.ToBase64String(Combine(salt, hash));
                }
            }
        }

        private static byte[] Combine(byte[] first, byte[] second)
        {
            byte[] combined = new byte[first.Length + second.Length];
            Buffer.BlockCopy(first, 0, combined, 0, first.Length);
            Buffer.BlockCopy(second, 0, combined, first.Length, second.Length);
            return combined;
        }

        public static bool VerifyPassword(string password, string hashedPassword)
        {
            byte[] hashBytes = Convert.FromBase64String(hashedPassword);

            byte[] salt = new byte[16]; // Salt 추출
            try
            {
                Buffer.BlockCopy(hashBytes, 0, salt, 0, 16);

                byte[] storedHash = new byte[32]; // 저장된 Hash 추출
                Buffer.BlockCopy(hashBytes, 16, storedHash, 0, 32);

                using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000, HashAlgorithmName.SHA256))
                {
                    byte[] computedHash = pbkdf2.GetBytes(32);

                    // 저장된 Hash와 비교
                    return FixedTimeEquals(storedHash, computedHash);
                }
            }
            catch {
                return false;
            }
        }

        private static bool FixedTimeEquals(byte[] array1, byte[] array2)
        {
            if (array1.Length != array2.Length)
            {
                return false;
            }

            int result = 0;
            for (int i = 0; i < array1.Length; i++)
            {
                result |= array1[i] ^ array2[i]; // XOR을 사용하여 차이점 계산
            }
            return result == 0; // 차이가 없으면 true, 차이가 있으면 false
        }

        public static bool VerifyPIN(string pin)
        {
            return (pin == App_GlobalResources.Constants.AdminPinNumber);
        }

        public static bool VerifyAdmin(Page page)
        {
            return page.Session["IsAdmin"] != null && (bool)page.Session["IsAdmin"];
        }
    }
}