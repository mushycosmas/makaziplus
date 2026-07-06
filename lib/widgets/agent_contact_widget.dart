// lib/widgets/agent_contact_widget.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../chat/chat_screen.dart';

class AgentContactWidget extends StatelessWidget {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? whatsapp;
  final String? avatar;
  final bool isAvailable;
  final String? role;
  final Map<String, dynamic>? property;

  const AgentContactWidget({
    super.key,
    this.fullName,
    this.email,
    this.phone,
    this.whatsapp,
    this.avatar,
    this.isAvailable = true,
    this.role = 'Agent',
    this.property,
  });

  // ✅ Launch phone call
  Future<void> _makePhoneCall() async {
    if (phone == null || phone!.isEmpty) {
      _showSnackbar('Phone number not available');
      return;
    }

    final url = 'tel:${phone!.replaceAll(RegExp(r'[^0-9]'), '')}';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        _showSnackbar('Cannot make call at this time');
      }
    } catch (e) {
      _showSnackbar('Error making call');
    }
  }

  // ✅ Launch WhatsApp
  Future<void> _openWhatsApp() async {
    final contact = whatsapp ?? phone;
    if (contact == null || contact.isEmpty) {
      _showSnackbar('Phone number not available');
      return;
    }

    final cleanNumber = contact.replaceAll(RegExp(r'[^0-9]'), '');
    final formattedNumber = cleanNumber.startsWith('255')
        ? cleanNumber
        : '255$cleanNumber';
    
    final propertyMessage = _buildPropertyMessage();
    final encodedMessage = Uri.encodeComponent(propertyMessage);
    final url = 'https://wa.me/$formattedNumber?text=$encodedMessage';
    
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        _showSnackbar('WhatsApp not installed or cannot open');
      }
    } catch (e) {
      _showSnackbar('Error opening WhatsApp');
    }
  }

  // ✅ Open Full Chat Screen (Like Bolt/Uber)
  void _openChatScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          fullName: fullName ?? 'Agent',
          avatar: avatar,
          property: property,
        ),
      ),
    );
  }

  // ✅ Send message (simulated - connects to your backend)
  void _sendMessage(String message) {
    print('Message sent to ${fullName ?? 'Agent'}: $message');
  }

  // ✅ Build property message
  String _buildPropertyMessage() {
    final propertyTitle = property?['title'] ?? 'Property';
    final propertyPrice = property?['price'] ?? 'N/A';
    final propertyLocation = _getPropertyLocation();
    
    return '''
Hello, I'm interested in the property "$propertyTitle" 
💰 Price: TSh $propertyPrice
📍 Location: $propertyLocation
📋 Property ID: ${property?['id'] ?? 'N/A'}

I would like to know more about this property. Please get back to me when you have a moment.

Thank you!''';
  }

  // ✅ Get property location
  String _getPropertyLocation() {
    if (property == null) return 'N/A';
    
    final ward = property!['ward'];
    final district = ward?['district'];
    final region = district?['region'];
    
    final parts = [
      ward?['name'],
      district?['name'],
      region?['name'],
    ].where((part) => part != null && part.isNotEmpty).toList();
    
    return parts.isNotEmpty ? parts.join(', ') : 'N/A';
  }

  // ✅ Show snackbar helper
  void _showSnackbar(String message) {
    // This will be called from build context
  }

  // ✅ Show message dialog with confirmation
  void _showMessageDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue[600],
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  // ✅ Handle contact action with confirmation
  void _handleContactAction(
    BuildContext context,
    String title,
    String message,
    VoidCallback action,
  ) {
    _showMessageDialog(context, title, message, action);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // AGENT INFO
          // =========================
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[100],
                backgroundImage: avatar != null && avatar!.isNotEmpty
                    ? NetworkImage(avatar!)
                    : null,
                child: avatar == null || avatar!.isEmpty
                    ? Text(
                        fullName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Name and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName ?? 'Unknown Agent',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (email != null && email!.isNotEmpty)
                      Text(
                        email!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 2),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: isAvailable ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isAvailable ? 'Available' : 'Unavailable',
                            style: TextStyle(
                              fontSize: 10,
                              color: isAvailable ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Role
                    if (role != null && role!.isNotEmpty)
                      Text(
                        role!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // =========================
          // CONTACT OPTIONS
          // =========================
          Row(
            children: [
              // 📞 Call Button
              Expanded(
                child: _buildContactButton(
                  icon: Icons.phone,
                  label: 'Call',
                  color: Colors.blue,
                  enabled: phone != null && phone!.isNotEmpty,
                  onPressed: () => _handleContactAction(
                    context,
                    'Call Agent',
                    'Call ${fullName ?? 'agent'} at ${phone ?? 'N/A'}?',
                    _makePhoneCall,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // 💬 WhatsApp Button
              Expanded(
                child: _buildContactButton(
                  icon: Icons.message,
                  label: 'WhatsApp',
                  color: Colors.green,
                  enabled: (whatsapp != null && whatsapp!.isNotEmpty) || 
                           (phone != null && phone!.isNotEmpty),
                  onPressed: () => _handleContactAction(
                    context,
                    'WhatsApp Agent',
                    'Open WhatsApp to chat with ${fullName ?? 'agent'}?',
                    _openWhatsApp,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // ✉️ Chat Button - Opens full screen
              Expanded(
                child: _buildContactButton(
                  icon: Icons.chat_bubble,
                  label: 'Chat',
                  color: Colors.purple,
                  enabled: true,
                  onPressed: () {
                    _openChatScreen(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: enabled ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? color.withOpacity(0.3) : Colors.grey[300]!,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: enabled ? color : Colors.grey[400],
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: enabled ? color : Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}