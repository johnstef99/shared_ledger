{{flutter_js}}
{{flutter_build_config}}

const loading = document.querySelector('#loading-indicator');
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();

    loading.remove();
    await appRunner.runApp();
  }
});
