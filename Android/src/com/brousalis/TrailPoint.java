package com.brousalis;

import java.util.Set;

import com.google.android.maps.GeoPoint;


public class TrailPoint extends InterestPoint {
	
	private String _trail;
	private Set<Integer> _connections;
	
	
	public TrailPoint(int id, int latitude, int longitude, String category, String summary, String title, String trail, Set<Integer> connections) {
		super(id, new GeoPoint(latitude, longitude), category, title, summary);
		_connections = connections;
		_trail = trail;
	}
	
	public TrailPoint(int id, GeoPoint p, String category, String summary, String title, String trail, Set<Integer> connections) {
		super(id, p, category, title, summary);
		_connections = connections;
		_trail = trail;
	}
	
	public void setTrail(String trail) {
		_trail = trail;
	}
	public String getTrail() {
		return _trail;
	}
	
	/**
	 * Set the connections set to a new set
	 * @param connections The new connection set
	 */
	public void setConnections(Set<Integer> connections) {
		_connections = connections;
	}
	/**
	 * Gets the connections 
	 * @return The current Set of connections
	 */
	public Set<Integer> getConnections() {
		return _connections;
	}
	/**
	 * Attempts to add a new connection to this point's connections
	 * @param connection The ID of a connection to add
	 * @return True if a connection was added, False if it already existed
	 */
	public boolean addConnection(Integer connection) {
		return _connections.add(connection);
	}
	/**
	 * Attempts to remove a connection from this point's connections
	 * @param connection The ID of a connection to delete
	 * @return True if a connection was removed, False if it did not exist
	 */
	public boolean removeConnection(Integer connection) {
		return _connections.remove(connection);
	}
	/**
	 * Checks to see if this TrailPoint has a connection
	 * @param connection The connection ID to check the Set against
	 * @return True if the connection's ID is in the Set, False if it is not
	 */
	public boolean hasConnection(Integer connection) {
		return _connections.contains(connection);
	}
}
