import psycopg2

try:
	conn = psycopg2.connect("dbname='appvno' user='postgres' password='4332wurx'")
	print("Connected to appvno database.")
except:
	print("Unable to connect to appvno database.")

cur = conn.cursor()

try:
	cur.execute("UPDATE notif_counter SET status='Expired' WHERE notif_count=120")
	conn.commit();
	print("Table notif_counter successfully updated.")
except:	
	print("Failed to update the table for notif_counter")
finally:
	if(conn):
		cur.close()
		conn.close()
		print("PostgreSQL connection is closed.")
