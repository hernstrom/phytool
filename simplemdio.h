#ifndef __SIMPLEMDIO_H
#define __SIMPLEMDIO_H

void phy_read_c45 (const char* port_name, uint8_t phy_addr, uint8_t dev_type, uint16_t reg_addr, uint16_t *const reg_value);
void phy_write_c45 (const char* port_name, uint8_t phy_addr, uint8_t dev_type, uint16_t reg_addr, uint16_t reg_value);
void phy_read_c22 (const char* port_name, uint8_t phy_addr, uint16_t reg_addr, uint16_t *const reg_value);
void phy_write_c22 (const char* port_name, uint8_t phy_addr, uint16_t reg_addr, uint16_t reg_value);

#endif	/* __SIMPLEMDIO_H */
