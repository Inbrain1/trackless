import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../1_auth/presentation/bloc/auth_bloc.dart';
import '../../../1_auth/presentation/bloc/auth_event.dart';

class AccountModal extends StatelessWidget {
  const AccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E), // Dark grey background like iOS
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Drag Handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8), // Reduced vertical padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
                const Text(
                  'Cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 40), // Balance spacing
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Profile Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80'), // Placeholder
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ibrain Caceres',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Editar Perfil',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section 1
                _buildSectionContainer(
                  children: [
                    _buildTile(
                      title: 'Configurar Perfil',
                      subtitle:
                          'Comparte tu música y ve lo que escuchan tus amigos.',
                      titleColor: Colors.redAccent,
                      showChevron: false,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section 2
                _buildSectionContainer(
                  children: [
                    _buildTile(
                        title: 'Canjear Tarjeta de Regalo o Código',
                        titleColor: Colors.redAccent),
                    _buildDivider(),
                    _buildTile(
                        title: 'Agregar Fondos', titleColor: Colors.redAccent),
                    _buildDivider(),
                    _buildTile(
                        title: 'Gestionar Suscripción',
                        titleColor: Colors.redAccent),
                    _buildDivider(),
                    _buildTile(
                        title: 'Plan Familiar', titleColor: Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 24),

                // Section 3: Notifications
                _buildSectionContainer(
                  children: [
                    _buildTile(title: 'Notificaciones'),
                  ],
                ),
                const SizedBox(height: 24),

                // Logout
                _buildSectionContainer(
                  children: [
                    _buildTile(
                        title: 'Cerrar Sesión',
                        titleColor: Colors.redAccent,
                        onTap: () {
                          Navigator.pop(context);
                          context.read<AuthBloc>().add(SignOutRequested());
                        },
                        showChevron: false,
                        centerTitle: true),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile({
    required String title,
    String? subtitle,
    Color titleColor = Colors.white,
    bool showChevron = true,
    bool centerTitle = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: centerTitle
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Colors.white12,
      indent: 16,
    );
  }
}
