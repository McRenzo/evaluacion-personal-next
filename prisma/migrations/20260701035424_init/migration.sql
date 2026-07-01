-- CreateEnum
CREATE TYPE "Rol" AS ENUM ('ADMIN', 'EVALUADOR');

-- CreateEnum
CREATE TYPE "EstadoPersonal" AS ENUM ('ACTIVO', 'INACTIVO');

-- CreateEnum
CREATE TYPE "EstadoPeriodo" AS ENUM ('ACTIVO', 'CERRADO', 'PENDIENTE');

-- CreateEnum
CREATE TYPE "EstadoEvaluacion" AS ENUM ('PENDIENTE', 'EN_PROCESO', 'FINALIZADA', 'FIRMADA');

-- CreateTable
CREATE TABLE "Personal" (
    "id" SERIAL NOT NULL,
    "dni" TEXT NOT NULL,
    "apellidos" TEXT NOT NULL,
    "nombres" TEXT NOT NULL,
    "cargo" TEXT NOT NULL,
    "estado" "EstadoPersonal" NOT NULL DEFAULT 'ACTIVO',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Personal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Acceso" (
    "id" SERIAL NOT NULL,
    "personalId" INTEGER NOT NULL,
    "password" TEXT NOT NULL,
    "rol" "Rol" NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "primerIngreso" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Acceso_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Periodo" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "anio" INTEGER NOT NULL,
    "fechaInicio" TIMESTAMP(3),
    "fechaFin" TIMESTAMP(3),
    "estado" "EstadoPeriodo" NOT NULL DEFAULT 'PENDIENTE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Periodo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ficha" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,
    "activa" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Ficha_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SeccionFicha" (
    "id" SERIAL NOT NULL,
    "fichaId" INTEGER NOT NULL,
    "nombre" TEXT NOT NULL,
    "orden" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SeccionFicha_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Criterio" (
    "id" SERIAL NOT NULL,
    "seccionId" INTEGER NOT NULL,
    "texto" TEXT NOT NULL,
    "orden" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Criterio_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Evaluacion" (
    "id" SERIAL NOT NULL,
    "periodoId" INTEGER NOT NULL,
    "fichaId" INTEGER NOT NULL,
    "evaluadorId" INTEGER NOT NULL,
    "evaluadoId" INTEGER NOT NULL,
    "estado" "EstadoEvaluacion" NOT NULL DEFAULT 'PENDIENTE',
    "puntajeTotal" INTEGER,
    "resultado" TEXT,
    "observacion" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Evaluacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Respuesta" (
    "id" SERIAL NOT NULL,
    "evaluacionId" INTEGER NOT NULL,
    "criterioId" INTEGER NOT NULL,
    "valor" INTEGER NOT NULL,
    "comentario" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Respuesta_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Documento" (
    "id" SERIAL NOT NULL,
    "evaluacionId" INTEGER NOT NULL,
    "nombre" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Documento_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Personal_dni_key" ON "Personal"("dni");

-- CreateIndex
CREATE UNIQUE INDEX "Acceso_personalId_key" ON "Acceso"("personalId");

-- CreateIndex
CREATE UNIQUE INDEX "Evaluacion_periodoId_evaluadorId_evaluadoId_fichaId_key" ON "Evaluacion"("periodoId", "evaluadorId", "evaluadoId", "fichaId");

-- CreateIndex
CREATE UNIQUE INDEX "Respuesta_evaluacionId_criterioId_key" ON "Respuesta"("evaluacionId", "criterioId");

-- AddForeignKey
ALTER TABLE "Acceso" ADD CONSTRAINT "Acceso_personalId_fkey" FOREIGN KEY ("personalId") REFERENCES "Personal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SeccionFicha" ADD CONSTRAINT "SeccionFicha_fichaId_fkey" FOREIGN KEY ("fichaId") REFERENCES "Ficha"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Criterio" ADD CONSTRAINT "Criterio_seccionId_fkey" FOREIGN KEY ("seccionId") REFERENCES "SeccionFicha"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Evaluacion" ADD CONSTRAINT "Evaluacion_periodoId_fkey" FOREIGN KEY ("periodoId") REFERENCES "Periodo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Evaluacion" ADD CONSTRAINT "Evaluacion_fichaId_fkey" FOREIGN KEY ("fichaId") REFERENCES "Ficha"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Evaluacion" ADD CONSTRAINT "Evaluacion_evaluadorId_fkey" FOREIGN KEY ("evaluadorId") REFERENCES "Personal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Evaluacion" ADD CONSTRAINT "Evaluacion_evaluadoId_fkey" FOREIGN KEY ("evaluadoId") REFERENCES "Personal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Respuesta" ADD CONSTRAINT "Respuesta_evaluacionId_fkey" FOREIGN KEY ("evaluacionId") REFERENCES "Evaluacion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Respuesta" ADD CONSTRAINT "Respuesta_criterioId_fkey" FOREIGN KEY ("criterioId") REFERENCES "Criterio"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Documento" ADD CONSTRAINT "Documento_evaluacionId_fkey" FOREIGN KEY ("evaluacionId") REFERENCES "Evaluacion"("id") ON DELETE CASCADE ON UPDATE CASCADE;
