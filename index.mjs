#!/usr/bin/env zx

const {
	GEOSERVER_VERSION = '2.27.1--v2025.07.17',
	IMAGE_DOCKER_REGISTRY,
	IMAGE_REPO = 'geoserver',
	WORK_DIR = '/tmp/geoserver',
} = process.env;

try {
	const packageVersion = await require('./package.json').version;
	const imageName = `${IMAGE_REPO}:v${packageVersion}-${GEOSERVER_VERSION}`;
	const geoserverBaseImageName = `kartoza/geoserver:${GEOSERVER_VERSION}`;

	await $`docker build -q --build-arg GEOSERVER_BASE_IMAGE=${geoserverBaseImageName} -f Dockerfile -t ${imageName} .`;

	console.log(chalk.blue('Builds Openshift ready Geoserver Image'));
	console.log(IMAGE_DOCKER_REGISTRY);

	if (IMAGE_DOCKER_REGISTRY) {
		const taggedImageName = `${IMAGE_DOCKER_REGISTRY}/${imageName}`;
		await $`docker tag ${imageName} ${taggedImageName}`;
		console.log(chalk.blue(`Tagged Docker Image as ${taggedImageName}`));
	}
	console.log(chalk.magenta('We did it!! 🐧🐧🐧🐧🐧'));
} catch (e) {
	console.log(chalk.red('Oh no! 😢'));
	console.error(e);
} finally {
	await $`rm -rf ${WORK_DIR}`;
}
