package com.selimhorri.app.jwt.util.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.selimhorri.app.jwt.util.JwtUtil;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Component
public class JwtUtilImpl implements JwtUtil {

	@org.springframework.beans.factory.annotation.Value("${jwt.secret:secret}")
	private String secretKey;

	@Override
	public String extractUsername(final String token) {
		return this.extractClaims(token, Claims::getSubject);
	}

	@Override
	public Date extractExpiration(final String token) {
		return this.extractClaims(token, Claims::getExpiration);
	}

	@Override
	public <T> T extractClaims(final String token, Function<Claims, T> claimsResolver) {
		final Claims claims = this.extractAllClaims(token);
		return claimsResolver.apply(claims);
	}

	private Claims extractAllClaims(final String token) {
		return Jwts.parser().setSigningKey(this.secretKey).parseClaimsJws(token).getBody();
	}

	private Boolean isTokenExpired(final String token) {
		return this.extractExpiration(token).before(new Date());
	}

	@Override
	public String generateToken(final UserDetails userDetails, final String userId) {
		final Map<String, Object> claims = new HashMap<>();
		claims.put("userId", userId);
		return this.createToken(claims, userDetails.getUsername());
	}

	private String createToken(final Map<String, Object> claims, final String subject) {
		return Jwts.builder()
				.setClaims(claims)
				.setSubject(subject)
				.setIssuedAt(new Date(System.currentTimeMillis()))
				.setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 10))
				.signWith(SignatureAlgorithm.HS256, this.secretKey)
				.compact();
	}

	@Override
	public Boolean validateToken(final String token, final UserDetails userDetails) {
		final String username = this.extractUsername(token);
		return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
	}

	@Override
	public String extractUserId(final String token) {
		return extractClaims(token, claims -> claims.get("userId", String.class));
	}

}
