// CommonCrypto has deprecated CC_MD5 and it is not included in catalyst. However, the last.fm api is old and it still uses md5 hashes and will likely never be updated to SHA, so this is the original apple implementation of CC_MD5 before being exported to CommonCrypto

#ifndef MD5_H
#define MD5_H


/* Unlike previous versions of this code, LONG need not be exactly
   32 bits, merely 32 bits or more.  Choosing a data type which is 32
   bits instead of 64 is not important; speed is considerably more
   important.  ANSI guarantees that "unsigned long" will be big enough,
   and always using it seems to have few disadvantages.  */
typedef uint32_t LONG;

#define MD5_DIGEST_LENGTH    16          /* digest length in bytes */
#define MD5_BLOCK_BYTES      64          /* block size in bytes */
#define MD5_BLOCK_LONG       (MD5_BLOCK_BYTES / sizeof(LONG))

void MD5(const void *data, LONG len, unsigned char *md);

#endif /* !MD5_H */
