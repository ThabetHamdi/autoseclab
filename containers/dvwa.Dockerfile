# Use a lightweight PHP / Apache setup or the vulnerables/web-dvwa base if available
FROM vulnerables/web-dvwa
EXPOSE 80
CMD ["/entrypoint.sh"]
