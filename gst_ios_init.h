
// gst_ios_init.h
// Created by Rakesh Kumar Biswal on 21/07/23.

#import <Availability.h>

#ifndef __IPHONE_5_0
#warning "This project uses features only available in iOS SDK 5.0 and later."
#endif

#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
#endif


#ifndef __GST_IOS_INIT_H__
#define __GST_IOS_INIT_H__



#define GST_G_IO_MODULE_DECLARE(name) \
extern void G_PASTE(g_io_, G_PASTE(name, _load)) (gpointer module)

#define GST_G_IO_MODULE_LOAD(name) \
G_PASTE(g_io_, G_PASTE(name, _load)) (NULL)

/* Uncomment each line to enable the plugin categories that your application needs.
 * You can also enable individual plugins. See gst_ios_init.c to see their names
 */

#define GST_IOS_PLUGINS_CORE
#define GST_IOS_PLUGINS_CODECS
//#define GST_IOS_PLUGINS_ENCODING
#define GST_IOS_PLUGINS_NET
#define GST_IOS_PLUGINS_PLAYBACK
#define GST_IOS_PLUGINS_VIS
#define GST_IOS_PLUGINS_SYS
#define GST_IOS_PLUGINS_EFFECTS
//#define GST_IOS_PLUGINS_CAPTURE
#define GST_IOS_PLUGINS_CODECS_GPL
#define GST_IOS_PLUGINS_CODECS_RESTRICTED
#define GST_IOS_PLUGINS_NET_RESTRICTED
//#define GST_IOS_PLUGINS_GES


#define GST_IOS_GIO_MODULE_GNUTLS

void gst_ios_init (void);


#endif
