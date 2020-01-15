/*****************************************************************************
 * CVS File Information :
 *    $RCSfile: reftree_const.h,v $
 *    $Author: dneckels $
 *    $Date: 2007/08/08 22:43:58 $
 *    Revision: 1.14 $
 ****************************************************************************/

#ifndef __REFTREE_CONST_H
#define __REFTREE_CONST_H

#ifdef __cplusplus
/* if C++, define the rest of this header file as extern C */
extern "C" {
#endif


/* Prototypes */

extern int Zoltan_Reftree_Set_Param(char *name, char *val);
extern void Zoltan_Reftree_Get_Child_Order(ZZ *zz, int *order, int *ierr);

#ifdef __cplusplus
} /* closing bracket for extern "C" */
#endif

#endif /* __REFTREE_CONST_H */
