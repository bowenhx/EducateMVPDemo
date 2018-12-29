/**
 -  ADHelper.m
 -  ADSDK
 -  Created by HY on 17/2/27.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BADGetparms.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>

@implementation BADGetparms

#pragma mark - 获取系统版本信息
+ (NSString *)mGetSystemVersion {
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}

#pragma mark - 获取当前应用版本号
+ (NSString *)mGetAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}

#pragma mark - 获取手机唯一标识符
+ (NSString *)mGetIdentifier {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

#pragma mark - 获取设备型号信息
+ (NSString *)mGetDeviceName {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BADDeviceName" ofType:@"plist"];
    if (!path) {
        NSLog(@"设备文件路径出错");
        return @"";
    }
    NSDictionary *deviceDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if (deviceDictionary[platform]) {
        return deviceDictionary[platform];
    } else {
        return @"";
    }
}

#pragma mark - 获取IP地址
+ (NSString *)mGetIPAddress {
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ) {
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}

@end
