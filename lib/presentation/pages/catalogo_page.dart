// lib/presentation/pages/catalogo_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../viewmodels/producto_state.dart';
import '../widgets/nav_drawer.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductoViewModel>().cargarProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductoViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const NavDrawer(),
      body: switch (vm.state.status) {
        ProductoStatus.loading => const Center(child: CircularProgressIndicator()),
        ProductoStatus.error   => Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text(vm.state.errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ProductoViewModel>().cargarProductos(),
              child: const Text('Reintentar'),
            ),
          ],
        )),
        ProductoStatus.success when vm.state.productos.isEmpty =>
          const Center(child: Text('No hay productos registrados.')),
        ProductoStatus.success => ListView.separated(
          padding:          const EdgeInsets.all(12),
          itemCount:        vm.state.productos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 6),
          itemBuilder: (ctx, i) {
            final p = vm.state.productos[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Text(p.nombre[0],
                    style: const TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold)),
                ),
                title: Text(p.nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${p.categoria}  |  Código: ${p.codigo}\n'
                    'Stock: ${p.stock} unidades'),
                isThreeLine: true,
                trailing: Text('S/ ${p.precio.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.indigo,
                    fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            );
          },
        ),
        _ => const Center(child: Text('Cargando catálogo...')),
      },
    );
  }
}
