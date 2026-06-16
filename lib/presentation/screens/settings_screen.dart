import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../presentation/blocs/settings/settings_bloc.dart';
import '../../presentation/blocs/settings/settings_event.dart';
import '../../presentation/blocs/settings/settings_state.dart';
import '../../domain/entities/ai_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});


  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            showErrorDialog(context, state.message);
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoaded) {
              // Debug log removed to satisfy production lint (avoid_print).
              // If needed, enable temporarily while testing.
            }
            if (state is SettingsLoading) {
              return const LoadingIndicator();
            } else if (state is SettingsLoaded) {
              return ListView(
                children: [

                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'AI Providers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (state.providers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No providers configured',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  else
                    ...state.providers.map((provider) {
                      final isSelected = provider.id == state.currentProvider?.id;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(provider.providerName),
                          subtitle: Text(provider.baseUrl),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected)
                                const Icon(Icons.check_circle, color: Colors.green),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text('Select'),
                                    onTap: () {
                                      context.read<SettingsBloc>().add(
                                        SetCurrentProviderEvent(provider.id),
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Edit'),
                                    onTap: () {
                                      _showProviderDialog(context, provider);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Delete'),
                                    onTap: () {
                                      context.read<SettingsBloc>().add(
                                        DeleteProviderEvent(provider.id),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            context.read<SettingsBloc>().add(
                              SetCurrentProviderEvent(provider.id),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed: () => _showProviderDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Provider'),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _showProviderDialog(BuildContext context, [AIProvider? existingProvider]) {
    final providerNameController =
        TextEditingController(text: existingProvider?.providerName ?? '');
    final baseUrlController =
        TextEditingController(text: existingProvider?.baseUrl ?? 'https://api.openai.com/v1');
    final modelController =
        TextEditingController(text: existingProvider?.model ?? 'gpt-3.5-turbo');
    final apiKeyController = TextEditingController(text: existingProvider?.apiKey ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingProvider == null ? 'Add Provider' : 'Edit Provider'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: providerNameController,
                decoration: const InputDecoration(labelText: 'Provider Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: baseUrlController,
                decoration: const InputDecoration(labelText: 'Base URL'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: apiKeyController,
                decoration: const InputDecoration(labelText: 'API Key'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (providerNameController.text.isNotEmpty &&
                  baseUrlController.text.isNotEmpty &&
                  modelController.text.isNotEmpty &&
                  apiKeyController.text.isNotEmpty) {
                final provider = AIProvider(
                  id: existingProvider?.id ?? const Uuid().v4(),
                  providerName: providerNameController.text,
                  baseUrl: baseUrlController.text,
                  model: modelController.text,
                  apiKey: apiKeyController.text,
                );

                context.read<SettingsBloc>().add(UpdateProviderEvent(provider));
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
