/* ====================================================================
 * The Apache Software License, Version 1.1
 *
 * Copyright (c) 2000-2003 The Apache Software Foundation.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by the
 *        Apache Software Foundation (http://www.apache.org/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The names "Apache" and "Apache Software Foundation" must
 *    not be used to endorse or promote products derived from this
 *    software without prior written permission. For written
 *    permission, please contact apache@apache.org.
 *
 * 5. Products derived from this software may not be called "Apache",
 *    nor may "Apache" appear in their name, without prior written
 *    permission of the Apache Software Foundation.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 */

/* 
 * Note: This is a Windows specific version of apu.h. It is renamed to
 * apu.h at the start of a Windows build.
 */
/* @file apu.h
 * @brief APR-Utility main file
 */

#ifdef WIN32
#ifndef APU_H
#define APU_H
/**
 * @defgroup APR_Util APR Utility Functions
 * @{
 */


/**
 * APU_DECLARE_EXPORT is defined when building the APR-UTIL dynamic library,
 * so that all public symbols are exported.
 *
 * APU_DECLARE_STATIC is defined when including the APR-UTIL public headers,
 * to provide static linkage when the dynamic library may be unavailable.
 *
 * APU_DECLARE_STATIC and APU_DECLARE_EXPORT are left undefined when
 * including the APR-UTIL public headers, to import and link the symbols from 
 * the dynamic APR-UTIL library and assure appropriate indirection and calling
 * conventions at compile time.
 */

#if !defined(WIN32)
/**
 * The public APR-UTIL functions are declared with APU_DECLARE(), so they may
 * use the most appropriate calling convention.  Public APR functions with 
 * variable arguments must use APU_DECLARE_NONSTD().
 *
 * @deffunc APU_DECLARE(rettype) apr_func(args);
 */
#define APU_DECLARE(type)            type
/**
 * The public APR-UTIL functions using variable arguments are declared with 
 * APU_DECLARE_NONSTD(), as they must use the C language calling convention.
 *
 * @deffunc APU_DECLARE_NONSTD(rettype) apr_func(args, ...);
 */
#define APU_DECLARE_NONSTD(type)     type
/**
 * The public APR-UTIL variables are declared with APU_DECLARE_DATA.
 * This assures the appropriate indirection is invoked at compile time.
 *
 * @deffunc APU_DECLARE_DATA type apr_variable;
 * @tip extern APU_DECLARE_DATA type apr_variable; syntax is required for
 * declarations within headers to properly import the variable.
 */
#define APU_DECLARE_DATA
#elif defined(APU_DECLARE_STATIC)
#define APU_DECLARE(type)            type __stdcall
#define APU_DECLARE_NONSTD(type)     type
#define APU_DECLARE_DATA
#elif defined(APU_DECLARE_EXPORT)
#define APU_DECLARE(type)            __declspec(dllexport) type __stdcall
#define APU_DECLARE_NONSTD(type)     __declspec(dllexport) type
#define APU_DECLARE_DATA             __declspec(dllexport)
#else
/**
 * The public APR-UTIL functions are declared with APU_DECLARE(), so they may
 * use the most appropriate calling convention.  Public APR functions with 
 * variable arguments must use APU_DECLARE_NONSTD().
 *
 */
#define APU_DECLARE(type)            __declspec(dllimport) type __stdcall
/**
 * The public APR-UTIL functions using variable arguments are declared with 
 * APU_DECLARE_NONSTD(), as they must use the C language calling convention.
 *
 */
#define APU_DECLARE_NONSTD(type)     __declspec(dllimport) type
/**
 * The public APR-UTIL variables are declared with APU_DECLARE_DATA.
 * This assures the appropriate indirection is invoked at compile time.
 *
 * @remark extern APU_DECLARE_DATA type apr_variable; syntax is required for
 * declarations within headers to properly import the variable.
 */
#define APU_DECLARE_DATA             __declspec(dllimport)
#endif
/** @} */
/*
 * we always have SDBM (it's in our codebase)
 */
#define APU_HAVE_SDBM   1
#define APU_HAVE_GDBM   0
#define APU_HAVE_DB     0

#if APU_HAVE_DB
#if APU_DBM_BERKELEYDB_PRIVATE 
/* this is only required for compiling dbm/apr_dbm_berkeleydb */
/* win32 note.. you will need to change this for db1 */
#include <db.h>
#endif
#endif

#define APU_HAVE_APR_ICONV     1
#define APU_HAVE_ICONV         0
#define APR_HAS_XLATE          (APU_HAVE_APR_ICONV || APU_HAVE_ICONV)

#endif /* APU_H */
#endif /* WIN32 */
