/*
 * This code implements the MD5 message-digest algorithm.
 * The algorithm is due to Ron Rivest.  This code was
 * written by Colin Plumb in 1993, no copyright is claimed.
 * This code is in the public domain; do with it what you wish.
 *
 * Equivalent code is available from RSA Data Security, Inc.
 * This code has been tested against that, and is equivalent,
 * except that you don't need to include two pages of legalese
 * with every copy.
 *
 * To compute the message digest of a chunk of bytes, declare an
 * MD5Context structure, pass it to MD5Init, call MD5Update as
 * needed on buffers full of bytes, and then call MD5Final, which
 * will fill a supplied 16-byte array with the digest.
 */

/* This code was modified in 1997 by Jim Kingdon of Cyclic Software to
   not require an integer type which is exactly 32 bits.  This work
   draws on the changes for the same purpose by Tatu Ylonen
   <ylo@cs.hut.fi> as part of SSH, but since I didn't actually use
   that code, there is no copyright issue.  I hereby disclaim
   copyright in any changes I have made; this code remains in the
   public domain.  */


#include <string.h>
#include "md5.h"

typedef struct MD5Context
{
    LONG A,B,C,D;
    LONG Nl,Nh;
    unsigned char data[MD5_BLOCK_BYTES];
} MD5_CTX;

void MD5(const void *data, LONG len, unsigned char *md);
void MD5Init(MD5_CTX *context);
void MD5Update(MD5_CTX *context, const void *data, LONG len);
void MD5Final(unsigned char digest[MD5_DIGEST_LENGTH], MD5_CTX *context);
void MD5Transform(MD5_CTX *context);

/* Little-endian byte-swapping routines.  Note that these do not
   depend on the size of datatypes such as LONG, nor do they require
   us to detect the endianness of the machine we are running on.  It
   is possible they should be macros for speed, but I would be
   surprised if they were a performance bottleneck for MD5.  */
static LONG
getu32 (const unsigned char *addr)
{
    return (((((LONG)addr[3] << 8) | addr[2]) << 8)
        | addr[1]) << 8 | addr[0];
}

void MD5(const void *data, LONG len, unsigned char *md) {
    MD5_CTX context;
    MD5Init(&context);
    MD5Update(&context, data, len);
    MD5Final(md, &context);
}

static void
putu32 (LONG data, unsigned char *addr)
{
    addr[0] = (unsigned char)data;
    addr[1] = (unsigned char)(data >> 8);
    addr[2] = (unsigned char)(data >> 16);
    addr[3] = (unsigned char)(data >> 24);
}

/*
 * Start MD5 accumulation.  Set bit count to 0 and buffer to mysterious
 * initialization constants.
 */
void
MD5Init(MD5_CTX *ctx)
{
    ctx->A = 0x67452301;
    ctx->B = 0xefcdab89;
    ctx->C = 0x98badcfe;
    ctx->D = 0x10325476;

    ctx->Nl = 0;
    ctx->Nh = 0;
}

/*
 * Update context to reflect the concatenation of another buffer full
 * of bytes.
 */
void
MD5Update(MD5_CTX *ctx, const void *buf, LONG len)
{
    LONG t;

    /* Update bitcount */

    t = ctx->Nl;
    if ((ctx->Nl = (t + ((LONG)len << 3)) & 0xffffffff) < t)
        ctx->Nh++;    /* Carry from low to high */
    ctx->Nh += len >> 29;

    t = (t >> 3) & 0x3f;    /* Bytes already in shsInfo->data */

    /* Handle any leading odd-sized chunks */

    if ( t ) {
        unsigned char *p = ctx->data + t;

        t = MD5_BLOCK_BYTES-t;
        if (len < t) {
            memcpy(p, buf, len);
            return;
        }
        memcpy(p, buf, t);
        MD5Transform(ctx);
        buf += t;
        len -= t;
    }

    /* Process data in 64-byte chunks */

    while (len >= MD5_BLOCK_BYTES) {
        memcpy(ctx->data, buf, MD5_BLOCK_BYTES);
        MD5Transform(ctx);
        buf += MD5_BLOCK_BYTES;
        len -= MD5_BLOCK_BYTES;
    }

    /* Handle any remaining bytes of data. */

    memcpy(ctx->data, buf, len);
}

/*
 * Final wrapup - pad to 64-byte boundary with the bit pattern
 * 1 0* (64-bit count of bits processed, MSB-first)
 */
void
MD5Final(unsigned char digest[MD5_DIGEST_LENGTH], MD5_CTX *ctx)
{
    unsigned count;
    unsigned char *p;

    /* Compute number of bytes mod 64 */
    count = (ctx->Nl >> 3) & 0x3F;

    /* Set the first char of padding to 0x80.  This is safe since there is
       always at least one byte free */
    p = ctx->data + count;
    *p++ = 0x80;

    /* Bytes of padding needed to make 64 bytes */
    count = MD5_BLOCK_BYTES - 1 - count;

    /* Pad out to 56 mod 64 */
    if (count < 8) {
        /* Two lots of padding:  Pad the first block to 64 bytes */
        memset(p, 0, count);
        MD5Transform(ctx);

        /* Now fill the next block with 56 bytes */
        memset(ctx->data, 0, 56);
    } else {
        /* Pad block to 56 bytes */
        memset(p, 0, count-8);
    }

    /* Append length in bits and transform */
    putu32(ctx->Nl, ctx->data + 56);
    putu32(ctx->Nh, ctx->data + 60);

    MD5Transform(ctx);
    putu32(ctx->A, digest);
    putu32(ctx->B, digest + 4);
    putu32(ctx->C, digest + 8);
    putu32(ctx->D, digest + 12);
    memset(ctx, 0, sizeof(MD5_CTX));    /* In case it's sensitive */
}

/* The four core functions - F1 is optimized somewhat */

/* #define F1(x, y, z) (x & y | ~x & z) */
#define F1(x, y, z) (z ^ (x & (y ^ z)))
#define F2(x, y, z) F1(z, x, y)
#define F3(x, y, z) (x ^ y ^ z)
#define F4(x, y, z) (y ^ (x | ~z))

/* This is the central step in the MD5 algorithm. */
#define MD5STEP(f, w, x, y, z, data, s) \
    ( w += f(x, y, z) + data, w &= 0xffffffff, w = w<<s | w>>(32-s), w += x )

/*
 * The core of the MD5 algorithm, this alters an existing MD5 hash to
 * reflect the addition of 16 longwords of new data.  MD5Update blocks
 * the data and converts bytes into longwords for this routine.
 */
void
MD5Transform(MD5_CTX *context)
{
    register LONG a, b, c, d;
    LONG in[MD5_DIGEST_LENGTH];
    
    for (int i = 0; i < MD5_DIGEST_LENGTH; ++i) {
        in[i] = getu32(context->data + 4 * i);
    }
        
    
    a = context->A;
    b = context->B;
    c = context->C;
    d = context->D;
    

    MD5STEP(F1, a, b, c, d, in[ 0]+0xd76aa478,  7);
    MD5STEP(F1, d, a, b, c, in[ 1]+0xe8c7b756, 12);
    MD5STEP(F1, c, d, a, b, in[ 2]+0x242070db, 17);
    MD5STEP(F1, b, c, d, a, in[ 3]+0xc1bdceee, 22);
    MD5STEP(F1, a, b, c, d, in[ 4]+0xf57c0faf,  7);
    MD5STEP(F1, d, a, b, c, in[ 5]+0x4787c62a, 12);
    MD5STEP(F1, c, d, a, b, in[ 6]+0xa8304613, 17);
    MD5STEP(F1, b, c, d, a, in[ 7]+0xfd469501, 22);
    MD5STEP(F1, a, b, c, d, in[ 8]+0x698098d8,  7);
    MD5STEP(F1, d, a, b, c, in[ 9]+0x8b44f7af, 12);
    MD5STEP(F1, c, d, a, b, in[10]+0xffff5bb1, 17);
    MD5STEP(F1, b, c, d, a, in[11]+0x895cd7be, 22);
    MD5STEP(F1, a, b, c, d, in[12]+0x6b901122,  7);
    MD5STEP(F1, d, a, b, c, in[13]+0xfd987193, 12);
    MD5STEP(F1, c, d, a, b, in[14]+0xa679438e, 17);
    MD5STEP(F1, b, c, d, a, in[15]+0x49b40821, 22);

    MD5STEP(F2, a, b, c, d, in[ 1]+0xf61e2562,  5);
    MD5STEP(F2, d, a, b, c, in[ 6]+0xc040b340,  9);
    MD5STEP(F2, c, d, a, b, in[11]+0x265e5a51, 14);
    MD5STEP(F2, b, c, d, a, in[ 0]+0xe9b6c7aa, 20);
    MD5STEP(F2, a, b, c, d, in[ 5]+0xd62f105d,  5);
    MD5STEP(F2, d, a, b, c, in[10]+0x02441453,  9);
    MD5STEP(F2, c, d, a, b, in[15]+0xd8a1e681, 14);
    MD5STEP(F2, b, c, d, a, in[ 4]+0xe7d3fbc8, 20);
    MD5STEP(F2, a, b, c, d, in[ 9]+0x21e1cde6,  5);
    MD5STEP(F2, d, a, b, c, in[14]+0xc33707d6,  9);
    MD5STEP(F2, c, d, a, b, in[ 3]+0xf4d50d87, 14);
    MD5STEP(F2, b, c, d, a, in[ 8]+0x455a14ed, 20);
    MD5STEP(F2, a, b, c, d, in[13]+0xa9e3e905,  5);
    MD5STEP(F2, d, a, b, c, in[ 2]+0xfcefa3f8,  9);
    MD5STEP(F2, c, d, a, b, in[ 7]+0x676f02d9, 14);
    MD5STEP(F2, b, c, d, a, in[12]+0x8d2a4c8a, 20);

    MD5STEP(F3, a, b, c, d, in[ 5]+0xfffa3942,  4);
    MD5STEP(F3, d, a, b, c, in[ 8]+0x8771f681, 11);
    MD5STEP(F3, c, d, a, b, in[11]+0x6d9d6122, 16);
    MD5STEP(F3, b, c, d, a, in[14]+0xfde5380c, 23);
    MD5STEP(F3, a, b, c, d, in[ 1]+0xa4beea44,  4);
    MD5STEP(F3, d, a, b, c, in[ 4]+0x4bdecfa9, 11);
    MD5STEP(F3, c, d, a, b, in[ 7]+0xf6bb4b60, 16);
    MD5STEP(F3, b, c, d, a, in[10]+0xbebfbc70, 23);
    MD5STEP(F3, a, b, c, d, in[13]+0x289b7ec6,  4);
    MD5STEP(F3, d, a, b, c, in[ 0]+0xeaa127fa, 11);
    MD5STEP(F3, c, d, a, b, in[ 3]+0xd4ef3085, 16);
    MD5STEP(F3, b, c, d, a, in[ 6]+0x04881d05, 23);
    MD5STEP(F3, a, b, c, d, in[ 9]+0xd9d4d039,  4);
    MD5STEP(F3, d, a, b, c, in[12]+0xe6db99e5, 11);
    MD5STEP(F3, c, d, a, b, in[15]+0x1fa27cf8, 16);
    MD5STEP(F3, b, c, d, a, in[ 2]+0xc4ac5665, 23);

    MD5STEP(F4, a, b, c, d, in[ 0]+0xf4292244,  6);
    MD5STEP(F4, d, a, b, c, in[ 7]+0x432aff97, 10);
    MD5STEP(F4, c, d, a, b, in[14]+0xab9423a7, 15);
    MD5STEP(F4, b, c, d, a, in[ 5]+0xfc93a039, 21);
    MD5STEP(F4, a, b, c, d, in[12]+0x655b59c3,  6);
    MD5STEP(F4, d, a, b, c, in[ 3]+0x8f0ccc92, 10);
    MD5STEP(F4, c, d, a, b, in[10]+0xffeff47d, 15);
    MD5STEP(F4, b, c, d, a, in[ 1]+0x85845dd1, 21);
    MD5STEP(F4, a, b, c, d, in[ 8]+0x6fa87e4f,  6);
    MD5STEP(F4, d, a, b, c, in[15]+0xfe2ce6e0, 10);
    MD5STEP(F4, c, d, a, b, in[ 6]+0xa3014314, 15);
    MD5STEP(F4, b, c, d, a, in[13]+0x4e0811a1, 21);
    MD5STEP(F4, a, b, c, d, in[ 4]+0xf7537e82,  6);
    MD5STEP(F4, d, a, b, c, in[11]+0xbd3af235, 10);
    MD5STEP(F4, c, d, a, b, in[ 2]+0x2ad7d2bb, 15);
    MD5STEP(F4, b, c, d, a, in[ 9]+0xeb86d391, 21);

    context->A += a;
    context->B += b;
    context->C += c;
    context->D += d;
}
