-- CreateEnum
CREATE TYPE "RsvpStatus" AS ENUM ('notInvited', 'invited', 'yes', 'no', 'maybe');

-- CreateTable
CREATE TABLE "guests" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "partySize" INTEGER NOT NULL DEFAULT 1,
    "side" TEXT,
    "rsvpStatus" "RsvpStatus" NOT NULL DEFAULT 'invited',
    "email" TEXT,
    "phone" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "guests_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "guests_rsvpStatus_idx" ON "guests"("rsvpStatus");

-- CreateIndex
CREATE INDEX "guests_side_idx" ON "guests"("side");

