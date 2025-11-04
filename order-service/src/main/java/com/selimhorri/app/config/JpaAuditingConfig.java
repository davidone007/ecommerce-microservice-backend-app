package com.selimhorri.app.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@Configuration
@EnableJpaAuditing
public class JpaAuditingConfig {
    // Enable JPA Auditing to auto-populate @CreatedDate and @LastModifiedDate fields
}
